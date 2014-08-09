#include <pthread.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <errno.h>
#include <sys/time.h>
#include <time.h>

void * Proc(void * arg)
{
    pthread_cond_t cond;
    pthread_mutex_t mutex;

    pthread_mutex_init(&mutex,NULL);
    pthread_cond_init(&cond,NULL);

    struct timespec to;

        struct timeval tv_s;
    int i = 0;
    while (i < 5) 
    {

        gettimeofday(&tv_s, NULL);
        to.tv_sec = tv_s.tv_sec + 3;
        to.tv_nsec = tv_s.tv_usec * 1000;
        


        int err = pthread_cond_timedwait(&cond, &mutex, &to);
        if (err ==ETIMEDOUT ) 
        {
            printf("time out %d: dispatch something..\n",i);
            fflush(stdout);
            i++;
        }

    }

    pthread_mutex_unlock(&mutex);


}
int main()
{    
    pthread_t pid;
    int i=0;
    printf("create thread...\n");
    fflush(stdout);
    pthread_create(&pid,0,Proc,0);
    pthread_join(pid,NULL);
    sleep(1);
    printf("Succeed exit!\n");
    fflush(stdout);
}


