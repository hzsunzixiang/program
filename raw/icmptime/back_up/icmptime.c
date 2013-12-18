/* much code stolen blatantly from the FreeBSD ping source */
/* It's ugly because the rest of it was ripped from some 
 * general ping sending code I wrote.
 *
 * author:  Dave Andersen
 *          angio@pobox.com  (danderse@cs.utah.edu for real work
 */

/*
 * Copyright (c) 1989, 1993
 *      The Regents of the University of California.  All rights reserved.
 *
 * This code is derived from software contributed to Berkeley by
 * Mike Muuss.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. All advertising materials mentioning features or use of this software
 *    must display the following acknowledgement:
 *      This product includes software developed by the University of
 *      California, Berkeley and its contributors.
 * 4. Neither the name of the University nor the names of its contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 */


#define A(bit)          rcvd_tbl[(bit)>>3]      /* identify byte in array */
#define B(bit)          (1 << ((bit) & 0x07))   /* identify bit in byte */
#define SET(bit)        (A(bit) |= B(bit))
#define CLR(bit)        (A(bit) &= (~B(bit)))
#define TST(bit)        (A(bit) & B(bit))

#include <time.h>
#include <sys/time.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>
#include <netinet/in.h>
#include <netinet/in_systm.h>
#include <netinet/ip.h>
#include <netinet/ip_icmp.h>
#include <errno.h>
#include <signal.h>
/*
 * If your kernel doesn't muck with raw packets, #define REALLY_RAW.
 * This is probably only Linux.
 */
#ifdef REALLY_RAW
#define FIX(x)  htons(x)
#else
#define FIX(x)  (x)
#endif

void usage()
{
		fprintf(stderr, "sendicmp  [-f fromhost] destination\n");
}

void pingcycle();
void doping(char *hostto, int s, char *hostfrom);

int targc = 0;
char **targv = NULL;
int ts = 0;
char *thostfrom = NULL;


		int
main(int argc, char **argv)
{
		int s;

		extern char *optarg;         /* getopt variable declarations */
		char *hostfrom = NULL;
		extern int optind;
		extern int optopt;
		extern int opterr;
		char ch;                     /* Holds the getopt result */
		int on = 1;

		while ((ch = getopt(argc, argv, "f:")) != EOF) 
				switch(ch)
				{
						case 'f':
								hostfrom = optarg;
								break;

						default:
								usage();
								exit(-1);
				}
		argc -= optind;
		argv += optind;

		if (!argv[0] || !strlen(argv[0])) 
		{
				usage();
				exit(-1);
		}

		if ((s = socket(AF_INET, SOCK_RAW, IPPROTO_RAW)) < 0) {
				perror("socket");
				exit(1);
		}
		if (setsockopt(s, IPPROTO_IP, IP_HDRINCL, &on, sizeof(on)) < 0) {
				perror("IP_HDRINCL");
				exit(1);
		}
		targc = argc;
		targv = argv;
		ts = s;
		thostfrom = hostfrom;
		pingcycle();
		exit(0);
}

void pingcycle() 
{
		char *nextun;

		signal(SIGALRM, pingcycle);
		alarm(5);
		while (targc > 0) 
		{
				targc--;
				nextun = targv[0];
				targv++;
				doping(nextun, ts, thostfrom);
		}
		exit(0);
}

void doping(char *hostto, int s, char *hostfrom) {
		u_char buf[1500];
		struct ip *ip = (struct ip *)buf;
		struct icmp *icmp = (struct icmp *)(ip + 1);
		struct hostent *hp;
		struct sockaddr_in dst;
		int on = 1;

		int offset;
		int typevar;
		int subtype;

		bzero(buf, sizeof buf);

		if ((hp = gethostbyname(hostto)) == NULL) {
				if ((ip->ip_dst.s_addr = inet_addr(hostto)) == -1) {
						fprintf(stderr, "%s: unknown host\n", hostto);
				}
		} else {
				bcopy(hp->h_addr_list[0], &ip->ip_dst.s_addr, hp->h_length);
		}

		ip->ip_src.s_addr = 0;	/* Default is to have kernel fill in */
		if (hostfrom != NULL) {
				if ((hp = gethostbyname(hostfrom)) == NULL) {
						if ((ip->ip_src.s_addr = inet_addr(hostto)) == -1) {
								ip->ip_src.s_addr = 0;	/* Kernel will fill in */
						}
				} else {
						bcopy(hp->h_addr_list[0], &ip->ip_src.s_addr, hp->h_length);
				}
		}
		if (ip->ip_src.s_addr)
				printf("Sending from %s\n", inet_ntoa(ip->ip_src));   

		ip->ip_v = 4;		/* Always use ipv4 for now */
		ip->ip_hl = sizeof *ip >> 2;
		ip->ip_tos = 0;
		ip->ip_len = sizeof(struct ip) + 20;
		ip->ip_id = htons(4321);
		ip->ip_ttl = 255;
		ip->ip_p = 1;
		ip->ip_sum = 0;                 /* kernel fills in */

		dst.sin_addr = ip->ip_dst;
		dst.sin_family = AF_INET;

		icmp->icmp_seq = 1;
		icmp->icmp_cksum = 0;
		icmp->icmp_type = ICMP_TSTAMP;
		icmp->icmp_code = 0;

		gettimeofday( (struct timeval *)(icmp+8), NULL);
		bzero( icmp+12, 8);
		icmp->icmp_cksum = in_cksum(icmp, 20);

		if (sendto(s, buf, sizeof buf, 0, (struct sockaddr *)&dst,
								sizeof dst) < 0) {
				perror("sendto");
		}
		usleep(1);

		while (1) 
		{
				int cc = 0;
				long int fromlen = sizeof dst;
				struct icmp *dicmp;
				struct ip   *dip;
				int hlen;
				struct timeval *tp;
				struct timeval tv;


				if ((cc = recvfrom(s, buf, sizeof buf, 0, (struct sockaddr *)&dst,
												(int *)&fromlen)) < 0)
				{
						if (errno == EINTR) continue;
						perror("icmptime:  recvfrom");
				}
				gettimeofday(&tv, NULL);

				dip = (struct ip*)buf;
				hlen = dip->ip_hl << 2;

				dicmp = (struct icmp *)(buf + hlen);
				if (dicmp->icmp_type != ICMP_TSTAMPREPLY) { continue; /* gah */ }

				fromlen = ntohl(icmp->icmp_ttime);

				/* Fromlen is in ms since midnight.  squawk. */

				tv.tv_usec = fromlen; /* annoying */
				tv.tv_usec = 0;
				tv.tv_sec -= tv.tv_sec%(24*60*60);
				tv.tv_sec += (fromlen/1000);
				tv.tv_usec = (fromlen%1000);

				printf("%-40.40s:  %s", hostto, ctime(&(tv.tv_sec)));

				break;
		}
}

/*
 * in_cksum --
 *	Checksum routine for Internet Protocol family headers (C Version)
 */

/*
 * Stolen horribly from the ping.c code.
 */

in_cksum(addr, len)
		u_short *addr;
		int len;
{
		register int nleft = len;
		register u_short *w = addr;
		register int sum = 0;
		u_short answer = 0;

		/*
		 * Our algorithm is simple, using a 32 bit accumulator (sum), we add
		 * sequential 16 bit words to it, and at the end, fold back all the
		 * carry bits from the top 16 bits into the lower 16 bits.
		 */
		while (nleft > 1)  {
				sum += *w++;
				nleft -= 2;
		}

		/* mop up an odd byte, if necessary */
		if (nleft == 1) {
				*(u_char *)(&answer) = *(u_char *)w ;
				sum += answer;
		}

		/* add back carry outs from top 16 bits to low 16 bits */
		sum = (sum >> 16) + (sum & 0xffff);	/* add hi 16 to low 16 */
		sum += (sum >> 16);			/* add carry */
		answer = ~sum;				/* truncate to 16 bits */
		return(answer);
}

