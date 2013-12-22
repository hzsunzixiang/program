#include <sys/socket.h>
#include <linux/netlink.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#include <string.h>
#include <stdio.h>

#define NETLINK_USER 31

#define MAX_PAYLOAD 1024 /* maximum payload size*/
struct sockaddr_nl src_addr, dest_addr;
//struct sockaddr_nl dest_addr;

//header
struct nlmsghdr *nlh = NULL;
struct iovec iov;
int sock_fd;
struct msghdr msg;

int main()
{
		sock_fd = socket(PF_NETLINK, SOCK_RAW, NETLINK_USER);
		if (sock_fd < 0)
				return -1;
		//http://inai.de/documents/Netlink_Protocol.pdf
		//
		//If  bind (2) is not explicitly called, it will be implicity invoked by the operating
		//system when one is about to establish a connection and/or send a datagram. An appropriate
		//address will be selected that the remote peer can reach too.
		memset(&src_addr, 0, sizeof(src_addr));
		src_addr.nl_family = AF_NETLINK;
		//src_addr.nl_pid = getpid(); /* self pid */
		// 这个是在协议字段中，内核返回的时候要以这个pid为准
		src_addr.nl_pid = 10000;/* self pid */

		bind(sock_fd, (struct sockaddr *)&src_addr, sizeof(src_addr));

		memset(&dest_addr, 0, sizeof(dest_addr));
		memset(&dest_addr, 0, sizeof(dest_addr));
		dest_addr.nl_family = AF_NETLINK;
		dest_addr.nl_pid = 0; /* For Linux Kernel */
		dest_addr.nl_groups = 0; /* unicast */

		nlh = (struct nlmsghdr *)malloc(NLMSG_SPACE(MAX_PAYLOAD));
		memset(nlh, 0, NLMSG_SPACE(MAX_PAYLOAD));
		nlh->nlmsg_len = NLMSG_SPACE(MAX_PAYLOAD);
		//nlh->nlmsg_pid = getpid();
		// 内核可以获得这个pid，但是发送的时候是一个src_addr中的pid为准的


		// 内核 可以获取这个pid号，发送的时候如果src_addr端口和这个不一样，就发送不了
		// 内核返回数据的时候必须和src_addr指定的pid一致
		nlh->nlmsg_pid = 10000;  // 这个内核可以在头部字段获取
		nlh->nlmsg_flags = 0;

		strcpy(NLMSG_DATA(nlh), "Hello");

		iov.iov_base = (void *)nlh;
		iov.iov_len = nlh->nlmsg_len;
		msg.msg_name = (void *)&dest_addr;
		msg.msg_namelen = sizeof(dest_addr);
		msg.msg_iov = &iov;
		msg.msg_iovlen = 1;

		printf("Sending message to kernel\n");
		sendmsg(sock_fd, &msg, 0);
		printf("Waiting for message from kernel\n");

		/* Read message from kernel */
		recvmsg(sock_fd, &msg, 0);
		printf("Received message payload: %s\n", (char*)NLMSG_DATA(nlh));
		close(sock_fd);
		return 0;
}
