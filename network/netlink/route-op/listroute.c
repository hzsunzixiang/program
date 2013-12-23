/* The purpose of this program is to monitor routing
 * table changes
 */

#include <sys/socket.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <linux/netlink.h>
#include <linux/rtnetlink.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <errno.h>

#define ERR_RET(x) do { perror(x); return EXIT_FAILURE; } while (0);
#define BUFFER_SIZE 4095

int  request_route(int sock, struct sockaddr_nl *addr)
{
		struct {
				struct nlmsghdr nlh;
				struct rtmsg rtm;
		} req;
		struct sockaddr_nl nladdr;

		memset(&nladdr, 0, sizeof(nladdr));
		memset(&req, 0, sizeof(req));
		nladdr.nl_family = AF_NETLINK;

		req.nlh.nlmsg_len = sizeof(req);
		req.nlh.nlmsg_type = RTM_GETROUTE;
		req.nlh.nlmsg_flags = NLM_F_ROOT|NLM_F_REQUEST;
		req.nlh.nlmsg_pid = 0;
		req.nlh.nlmsg_seq = 10000;
		req.rtm.rtm_family = AF_INET;
		req.rtm.rtm_flags |= RTM_F_CLONED;

		return sendto(sock, (void*)&req, sizeof(req), 0, (struct sockaddr*)&nladdr, sizeof(nladdr));

		return 0;
}
int parse_rtattr_flags(struct rtattr *tb[], int max, struct rtattr *rta,
				int len, unsigned short flags)
{
		unsigned short type;

		memset(tb, 0, sizeof(struct rtattr *) * (max + 1));
		while (RTA_OK(rta, len)) {
				type = rta->rta_type & ~flags;
				if ((type <= max) && (!tb[type]))
						tb[type] = rta;
				rta = RTA_NEXT(rta,len);
		}
		if (len)
				fprintf(stderr, "!!!Deficit %d, rta_len=%d\n", len, rta->rta_len);
		return 0;
}

int print_route(struct sockaddr_nl *who, struct nlmsghdr *n)
{
		struct rtmsg *r = NLMSG_DATA(n);
		int len = n->nlmsg_len;
		struct rtattr * tb[RTA_MAX+1];
		char abuf[256];
		int host_len = -1;
		__u32 table;
		static int hz;

		if (n->nlmsg_type != RTM_NEWROUTE && n->nlmsg_type != RTM_DELROUTE) {
				fprintf(stderr, "Not a route: %08x %08x %08x\n",
								n->nlmsg_len, n->nlmsg_type, n->nlmsg_flags);
				return 0;
		}
		len -= NLMSG_LENGTH(sizeof(*r));
		if (len < 0) {
				fprintf(stderr, "BUG: wrong nlmsg len %d\n", len);
				return -1;
		}

		parse_rtattr_flags(tb, RTA_MAX, RTM_RTA(r), len,0);
		if (tb[RTA_DST]) {
				fprintf(stdout, "%s/%u\n ",inet_ntop(r->rtm_family,
										RTA_DATA(tb[RTA_DST]),
										abuf, sizeof(abuf)),r->rtm_dst_len );
		}
		else if (r->rtm_dst_len) {
				fprintf(stdout, "0/%d \n", r->rtm_dst_len);
		} else {
				fprintf(stdout, "default ");
		}
		if (tb[RTA_SRC]) {
				fprintf(stdout, "%s/%u \n",inet_ntop(r->rtm_family,
										RTA_DATA(tb[RTA_SRC]),
										abuf, sizeof(abuf)),r->rtm_dst_len );
		}
		else if (r->rtm_dst_len) {
				fprintf(stdout, "0/%d\n ", r->rtm_dst_len);
		} else {
				fprintf(stdout, "default ");
		}


}
int receive_route(int sock)
{
		struct sockaddr_nl nladdr;
		struct iovec iov;
		struct msghdr msg = {
				.msg_name = &nladdr,
				.msg_namelen = sizeof(nladdr),
				.msg_iov = &iov,
				.msg_iovlen = 1,
		};
		char buf[16384];
		int dump_intr = 0;

		iov.iov_base = buf;
		while (1) {
				int status;
				int found_done = 0;
				int msglen = 0;

				iov.iov_len = sizeof(buf);
				status = recvmsg(sock, &msg, 0);

				if (status < 0) {
						if (errno == EINTR || errno == EAGAIN)
								continue;
						fprintf(stderr, "netlink receive error %s (%d)\n",
										strerror(errno), errno);
						return -1;
				}

				if (status == 0) {
						fprintf(stderr, "EOF on netlink\n");
						return -1;
				}

				struct nlmsghdr *h = (struct nlmsghdr*)buf;
				msglen = status;

				while (NLMSG_OK(h, msglen)) {
						int err;
						if (h->nlmsg_flags & NLM_F_DUMP_INTR)
								dump_intr = 1;

						if (h->nlmsg_type == NLMSG_DONE) {
								found_done = 1;
								break; /* process next filter */
						}
						if (h->nlmsg_type == NLMSG_ERROR) {
								struct nlmsgerr *err = (struct nlmsgerr*)NLMSG_DATA(h);
								if (h->nlmsg_len < NLMSG_LENGTH(sizeof(struct nlmsgerr))) {
										fprintf(stderr,
														"ERROR truncated\n");
								} else {
										errno = -err->error;
										perror("RTNETLINK answers");
								}
								return -1;
						}
						//	err = a->filter(&nladdr, h, a->arg1);
						//	if (err < 0)
						//			return err;
						print_route(&nladdr, h);
						h = NLMSG_NEXT(h, msglen);
				}

				if (found_done) {
						if (dump_intr)
								fprintf(stderr,
												"Dump was interrupted and may be inconsistent.\n");
						return 0;
				}

				if (msg.msg_flags & MSG_TRUNC) {
						fprintf(stderr, "Message truncated\n");
						continue;
				}
				if (msglen) {
						fprintf(stderr, "!!!Remnant of size %d\n", msglen);
						exit(1);
				}
		}

}

int main(int argc, char **argv)
{
		int sock = -1;
		struct sockaddr_nl addr;

		/* Zeroing addr */
		bzero (&addr, sizeof(addr));

		if ((sock = socket(AF_NETLINK, SOCK_RAW, NETLINK_ROUTE)) < 0)
				ERR_RET("socket");

		addr.nl_family = AF_NETLINK;
		//addr.nl_groups = RTMGRP_IPV4_ROUTE;
		addr.nl_groups = 0;

		if (bind(sock,(struct sockaddr *)&addr,sizeof(addr)) < 0)
				ERR_RET("bind");

		if (request_route (sock, &addr)<0)
				ERR_RET("request");
		receive_route(sock);

		/* Close socket */
		close(sock);

		return 0;
}
