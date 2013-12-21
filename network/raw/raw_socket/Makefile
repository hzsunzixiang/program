.PHONY:clean all
CC=gcc
CFLAGS=-Wall -g
BIN=receive send
all:$(BIN)
%.o:%.c
	$(CC) $(CFLAGS) -c $< -o $@
clean:
	rm -f *.o $(BIN)
