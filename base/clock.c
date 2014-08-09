#include<stdio.h>
#include <unistd.h>
int main()
{
    long ticks;

    if ((ticks = sysconf(_SC_CLK_TCK)) == -1) {
        perror("sysconf");
    }


    printf("ticks\t%d\n",ticks);
    return 0;
}
