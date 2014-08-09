#include <pthread.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/time.h>
#include <time.h>

void * Proc(void * arg)
{
    pthread_cond_t cond;
    pthread_mutex_t mutex;

    pthread_mutex_init(&mutex,NULL);
    pthread_cond_init(&cond,NULL);

    timespec to;

    int i = 0;
    pthread_mutex_lock(&mutex);
    to.tv_sec = time(NULL) + 3;
    to.tv_nsec = 0;
    while (i < 5) 
    {

        int err = pthread_cond_timedwait(&cond, &mutex, &to);
        if (err == ETIMEDOUT) 
        {
            printf("time out %d: dispatch something.../n",i);
            i++;
        }

    }

    pthread_mutex_unlock(&mutex);


}
//int main()
//{    
//    pthread_t pid;
//    int i=0;
//    printf("create thread.../n");
//    pthread_create(&pid,0,Proc,0);
//    pthread_join(pid,NULL);
//    sleep(1);
//    printf("Succeed exit!/n");
//}
//
//
