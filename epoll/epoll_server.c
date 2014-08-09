#include <iostream> 
#include <sys/socket.h>  
#include <sys/epoll.h>  
#include <netinet/in.h>  
#include <arpa/inet.h>  
#include <fcntl.h>  
#include <unistd.h>  
#include <stdio.h>  
#include <errno.h>  
#include <stdlib.h>  
#include <string.h>  
using namespace std; 

#define MAXLINE 512  
#define OPEN_MAX 100  
#define LISTENQ 20  
#define SERV_PORT  9876 
#define INFTIM 1000  

void setnonblocking(int sock)  
{  
		int opts;  
		opts=fcntl(sock,F_GETFL);  

		if(opts<0)  
		{  
				perror("fcntl(sock,GETFL)");  
				exit(1);  
		}  

		opts = opts | O_NONBLOCK;  

		if(fcntl(sock,F_SETFL,opts)<0)  
		{  
				perror("fcntl(sock,SETFL,opts)");  
				exit(1);  
		}  
}  




/* 
   ¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿ 
   (¿¿¿epoll¿¿¿¿¿¿¿¿¿¿socket¿¿), 
   ¿¿¿¿¿¿¿socket,¿¿send()¿¿¿¿¿¿, 
   ¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿, 
   ¿¿¿¿¿¿¿¿¿ 
   ¿¿¿¿¿¿¿¿¿EAGAIN¿¿(¿¿man send),¿¿, 
   ¿¿¿¿¿¿¿¿¿¿¿¿.¿¿, 
   ¿¿¿¿socket_send()¿¿¿¿¿¿¿¿¿¿¿, 
   ¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿-1¿¿¿¿¿ 
   ¿socket_send()¿¿,¿¿¿¿¿¿(send()¿¿-1,¿errno¿EAGAIN), 
   ¿¿¿¿¿¿¿¿¿.¿¿¿¿¿¿¿¿¿, 
   ¿¿¿¿¿¿¿¿¿¿¿¿¿¿socket_send()¿¿, 
   ¿¿¿¿¿¿¿¿¿. 

 */ 

ssize_t socket_send(int sockfd, const char* buffer, size_t buflen) 
{ 
		ssize_t tmp; 
		size_t total = buflen; 
		const char *p = buffer; 

		while(1) 
		{ 
				tmp = send(sockfd, p, total, 0); 
				if(tmp < 0) 
				{ 
						// ¿send¿¿¿¿¿,¿¿¿¿¿,¿¿¿¿¿-1. 
						if(errno == EINTR) 
								//return -1;zxd 
								continue; 

						// ¿socket¿¿¿¿¿,¿¿¿¿¿¿,¿¿¿¿¿¿¿¿¿, 
						// ¿¿¿¿¿¿¿¿¿¿. 
						if(errno == EAGAIN) 
						{ 
								usleep(1000); 
								continue; 
						} 

						return -1; 
				} 

				if((size_t)tmp == total) 
						return buflen; 

				total -= tmp; 
				p += tmp; 
		} 

		return tmp; 
} 


void epoll_ctl_err_show()   
{   
		std::cout << "error at epoll_ctl" << std::endl;   
		if(EBADF == errno)   
		{   
				std::cout << "error at epoll_ctl, error  is EBADF" << std::endl;   
		}   
		else if(EEXIST == errno)   
		{   
				std::cout << "error at epoll_ctl, error  is EEXIST" << std::endl;   
		}   
		else if(EINVAL == errno)   
		{   
				std::cout << "error at epoll_ctl, error  is EINVAL" << std::endl;   
		}   
		else if(ENOENT == errno)   
		{   
				std::cout << "error at epoll_ctl, error  is ENOENT" << std::endl;   
		}   
		else if(ENOMEM == errno)   
		{   
				std::cout << "error at epoll_ctl, error  is ENOMEM" << std::endl;   
		}   
		else if(ENOSPC == errno)   
		{   
				std::cout << "error at epoll_ctl, error  is ENOSPC" << std::endl;   
		}   

}  

int main()  
{  
		int i, maxi, listenfd, connfd, sockfd, epfd, nfds;  
		ssize_t n;  
		char line[MAXLINE];  
		socklen_t clilen;  

		struct epoll_event ev,events[20]; //¿¿epoll_event¿¿¿¿¿¿, ev¿¿¿¿¿¿, events¿¿¿¿¿¿¿¿¿¿¿¿  
		epfd=epoll_create(256); //¿¿¿¿¿¿accept¿epoll¿¿¿¿¿¿¿¿, ¿¿¿¿¿¿¿¿¿¿¿¿¿256  

		struct sockaddr_in clientaddr;  
		struct sockaddr_in serveraddr;  

		listenfd = socket(AF_INET, SOCK_STREAM, 0);  

		setnonblocking(listenfd); //¿¿¿¿¿¿socket¿¿¿¿¿¿¿¿  

		ev.data.fd=listenfd; //¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿  
		ev.events=EPOLLIN | EPOLLET; //¿¿¿¿¿¿¿¿¿¿  
		epoll_ctl(epfd,EPOLL_CTL_ADD,listenfd,&ev); //¿¿epoll¿¿ 

		bzero(&serveraddr, sizeof(serveraddr));  
		serveraddr.sin_family = AF_INET;  
		char *local_addr="127.0.0.1";  
		inet_aton(local_addr,&(serveraddr.sin_addr)); 
		serveraddr.sin_port=htons(SERV_PORT);  //¿¿htons(SERV_PORT);  

		bind(listenfd,(sockaddr *)&serveraddr, sizeof(serveraddr));  

		listen(listenfd, LISTENQ);  

		maxi = 0;  

		for( ; ; ) {  
				nfds=epoll_wait(epfd, events, 20, -1); //¿¿epoll¿¿¿¿¿  


				for(i=0;i<nfds;++i) //¿¿¿¿¿¿¿¿¿¿  
				{  
						if(events[i].data.fd==listenfd)    /**¿¿¿¿**/ 
						{  
								//¿¿accept 
								while((connfd = accept(listenfd,(sockaddr *)&clientaddr, &clilen)) > 0) 
								{ 
										setnonblocking(connfd); //¿¿¿¿¿socket¿¿¿¿¿¿¿¿ 

										char *str = inet_ntoa(clientaddr.sin_addr);  
										std::cout<<"connect from "<<str<<std::endl;  

										ev.data.fd=connfd; //¿¿¿¿¿¿¿¿¿¿¿¿¿  
										ev.events=EPOLLIN | EPOLLET; //¿¿¿¿¿¿¿¿¿¿¿¿  
										epoll_ctl(epfd,EPOLL_CTL_ADD,connfd,&ev); //¿¿ev¿¿  
								} 
						}  
						else if(events[i].events&EPOLLIN)     /**¿¿¿**/ 
						{  
								//fprintf(stderr, "EPOLLIN................%d\n", maxi++); 
								if ( (sockfd = events[i].data.fd) < 0)  
								{ 
										continue;  
								} 
								memset(line, 0, MAXLINE); 
								n = 0; 
								int nread = 0; 
							while((nread= read(sockfd, line + n, MAXLINE)) > 0) 
								{ 
										n += nread; 
								}//¿¿EAGAIN¿¿¿¿¿¿ 


								if(nread == -1 && errno != EAGAIN) 
								{ 
										epoll_ctl_err_show(); 
										std::cout<<"readline error"<<std::endl; 
										close(sockfd); //¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿epoll¿¿¿¿¿¿¿ 
										//¿¿¿¿¿¿¿¿¿¿¿¿¿¿EPOLLOUT¿¿¿¿¿¿¿¿¿¿ 
										events[i].data.fd = -1;  
								} 

								//¿¿¿¿¿¿¿¿nread¿0¿¿¿¿¿¿¿¿¿¿¿ 
								//¿¿¿¿¿¿¿¿¿¿¿¿¿¿/proc/id/fd¿¿¿¿¿¿¿¿¿¿¿¿ 
								if(nread == 0) 
								{ 
										close(sockfd); 
										continue; 
								} 


								ev.data.fd=sockfd; //¿¿¿¿¿¿¿¿¿¿¿¿¿  
								ev.events=EPOLLOUT | EPOLLET; //¿¿¿¿¿¿¿¿¿¿¿¿  
								epoll_ctl(epfd,EPOLL_CTL_MOD,sockfd,&ev); //¿¿sockfd¿¿¿¿¿¿¿¿EPOLLOUT  
						}  
						else if(events[i].events & EPOLLOUT)    /**¿¿¿**/ 
						{  
								sockfd = events[i].data.fd;  
								//write(sockfd, line, n); orig 

								int iRet = socket_send(sockfd, line, strlen(line) + 1); 
								if(iRet == -1 || iRet != strlen(line) + 1) 
								{ 
										perror("write error!"); 
								}/*zxd*/ 

								ev.data.fd=sockfd; //¿¿¿¿¿¿¿¿¿¿¿¿¿  
								ev.events=EPOLLIN | EPOLLET; //¿¿¿¿¿¿¿¿¿¿¿¿  
								epoll_ctl(epfd, EPOLL_CTL_MOD, sockfd, &ev); //¿¿sockfd¿¿¿¿¿¿¿¿EPOLIN  
						}  
				}  
		}  
} 
