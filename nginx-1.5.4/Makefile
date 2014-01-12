
default:	build

clean:
	rm -rf Makefile objs

build:
	$(MAKE) -f objs/Makefile
	$(MAKE) -f objs/Makefile manpage

install:
	$(MAKE) -f objs/Makefile install

upgrade:
	./object_helloworld/sbin/nginx -t

	kill -USR2 `cat ./object_helloworld/logs/nginx.pid`
	sleep 1
	test -f ./object_helloworld/logs/nginx.pid.oldbin

	kill -QUIT `cat ./object_helloworld/logs/nginx.pid.oldbin`
