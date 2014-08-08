#define _GNU_SOURCE     /* syscall() is not POSIX */

#include <stdio.h>      /* for perror() */
#include <stdlib.h>     /*malloc*/
#include <unistd.h>     /* for syscall() */
#include <sys/syscall.h>    /* for __NR_* definitions */
#include <fcntl.h>      /* O_RDWR */
#include <string.h>     /* memset() */
#include <inttypes.h>   /* uint64_t */
#include<libaio.h>

int main(int argc, char *argv[])
{
    // 每次读入32K字节
    const int buffer_size = 0x8000;

    // 最大事件数 32
    const int nr_events   = 32;
    int rt;

    io_context_t ctx ={0};

    // 初使化 io_context_t
    rt = io_setup(nr_events, &ctx);
    if ( rt != 0 )
        perror("io_setup error");

    // 依次读取参数作为文件名加入提交到ctx
    int pagesize = sysconf(_SC_PAGESIZE);
    int i = 1;
    for ( i=1; i<argc; ++i) {
        struct iocb *cb = (struct iocb*)malloc(sizeof(struct iocb));
        void *buffer;
        // 要使用O_DIRECT, 必须要对齐
        posix_memalign(&buffer, pagesize, buffer_size);
        io_prep_pread(cb, open(argv[i], O_RDONLY | O_DIRECT), buffer, buffer_size, 0);
        rt = io_submit(ctx, 1, &cb);
        if (rt < 0)
            perror("io_submit ");;
    }

    printf("io_prep_pread over \n");
    struct io_event events[nr_events];
    struct iocb     *cbs[nr_events];

    int remain = argc - 1;
    int n      = 0;

    // 接收数据最小返回的请求数为1，最大为nr_events
    while (remain && (n = io_getevents(ctx, 1, nr_events, events, 0))) {
        int nr_cbs = 0;
        int i = 0 ;
        for (i=0; i<n; ++i) {
            struct io_event event = events[i];
            struct iocb     *cb    = event.obj;
            // event.res为unsigned
            //printf("%d receive %d bytes\n", cb->aio_fildes, event.res);
            if (event.res > buffer_size) {
                printf("%s\n", strerror(-event.res));
            }
            if (event.res != buffer_size || event.res2 != 0) {
                --remain;
                printf("if %s",cb->u.c.buf);
                // 释放buffer, fd 与 cb
                free(cb->u.c.buf);
                close(cb->aio_fildes);
                free(cb);
            } else {
                printf("else%s",cb->u.c.buf);
                // 更新cb的offset
                cb->u.c.offset += event.res;
                cbs[nr_cbs++] = cb;
            }
        }

        if (nr_cbs) {
            // 继续接收数据
            io_submit(ctx, nr_cbs, cbs);
        }
    }
    return 0;
}
