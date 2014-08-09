#include <stdio.h>
#include <stdlib.h>

int main()
{
    printf("Hellow World!......\n");
    fflush(stdout);
    daemon(0,0);

    while(1)
    {
       printf("Hellow World!\n");

       sleep(100000);

    }
}
