
default:	build

clean:
	rm -rf Makefile objs

build:
	$(MAKE) -f objs/Makefile
	$(MAKE) -f objs/Makefile manpage

install:
	$(MAKE) -f objs/Makefile install

upgrade:
	./object/sbin/nginx -t

	kill -USR2 `cat ./object/logs/nginx.pid`
	sleep 1
	test -f ./object/logs/nginx.pid.oldbin

	kill -QUIT `cat ./object/logs/nginx.pid.oldbin`
