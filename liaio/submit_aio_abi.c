#define _GNU_SOURCE     /* syscall() is not POSIX */

#include <stdio.h>      /* for perror() */
#include <stdlib.h>     /*malloc*/
#include <unistd.h>     /* for syscall() */
#include <sys/syscall.h>    /* for __NR_* definitions */
#include <linux/aio_abi.h>  /* for AIO types and constants */
#include <fcntl.h>      /* O_RDWR */
#include <string.h>     /* memset() */
#include <inttypes.h>   /* uint64_t */

inline int io_setup(unsigned nr, aio_context_t *ctxp)
{
    return syscall(__NR_io_setup, nr, ctxp);
}

inline int io_destroy(aio_context_t ctx) 
{
    return syscall(__NR_io_destroy, ctx);
}

inline int io_submit(aio_context_t ctx, long nr,  struct iocb **iocbpp) 
{
    return syscall(__NR_io_submit, ctx, nr, iocbpp);
}

inline int io_getevents(aio_context_t ctx, long min_nr, long max_nr,
        struct io_event *events, struct timespec *timeout)
{
    return syscall(__NR_io_getevents, ctx, min_nr, max_nr, events, timeout);
}

int main(int argc, char *argv[])
{
    // 每次读入32K字节
    const int buffer_size = 0x8000;

    // 最大事件数 32
    const int nr_events   = 32;
    int rt;

    io_context_t ctx = 0;

    // 初使化 io_context_t
    rt = io_setup(nr_events, &ctx);
    if ( rt != 0 )
        perror("io_setup error");

    // 依次读取参数作为文件名加入提交到ctx
    int pagesize = sysconf(_SC_PAGESIZE);
    for (int i=1; i<argc; ++i) {
        struct iocb *cb = (struct iocb*)malloc(sizeof(struct iocb));
        void *buffer;
        // 要使用O_DIRECT, 必须要对齐
        posix_memalign(&buffer, pagesize, buffer_size);
        //io_prep_pread(cb, open(argv[i], O_RDONLY | O_DIRECT), buffer, buffer_size, 0);
        cb.aio_fildes =  fd;
        cb.aio_lio_opcode = IOCB_CM_PREAD;
        cb.aio_buf = buffer;
        cb.offset = 0;
        cb.aio_nbytes = 4096;
        rt = io_submit(ctx, 1, &cb);
        if (rt < 0)
            perror("io_submit");;
    }

    io_event events[nr_events];
    iocb     *cbs[nr_events];

    int remain = argc - 1;
    int n      = 0;

    // 接收数据最小返回的请求数为1，最大为nr_events
    while (remain && (n = io_getevents(ctx, 1, nr_events, events, 0))) {
        int nr_cbs = 0;
        for (int i=0; i<n; ++i) {
            io_event &event = events[i];
            iocb     *cb    = event.obj;
            // event.res为unsigned
            //printf("%d receive %d bytes\n", cb->aio_fildes, event.res);
            if (event.res > buffer_size) {
                printf("%s\n", strerror(-event.res));
            }
            if (event.res != buffer_size || event.res2 != 0) {
                --remain;
                // 释放buffer, fd 与 cb
                free(cb->u.c.buf);
                close(cb->aio_fildes);
                free(cb);
            } else {
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
