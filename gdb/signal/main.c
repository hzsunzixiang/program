#include<stdio.h>
#include <sys/types.h>
#include <unistd.h>
#include <signal.h>
#include"hello.h"
int var;

int main()
{


    int i;
    int j;
    i=1;
    j=2;
    var = 10;


    printf("%d\n",i);
    var = i+j;
    printf("%d\n",j);

    printf("%d,\n",print(boring()));

    kill(getpid(),2);

    printf("%d\n",var);
    return 0;
}
