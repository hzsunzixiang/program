root@szx-iptables-2:/etc/squid/squid-reverse# ip r
default via 10.160.30.15 dev eth0
10.160.30.0/23 dev eth0  proto kernel  scope link  src 10.160.30.97
192.168.2.0/24 dev br100  proto kernel  scope link  src 192.168.2.77
root@szx-iptables-2:/etc/squid/squid-reverse# ip a eth0
Command "eth0" is unknown, try "ip addr help".
root@szx-iptables-2:/etc/squid/squid-reverse# ip a s eth0
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
    link/ether fa:16:3e:0c:d6:ea brd ff:ff:ff:ff:ff:ff
    inet 10.160.30.97/23 brd 10.160.31.255 scope global eth0
    inet6 fe80::f816:3eff:fe0c:d6ea/64 scope link tentative dadfailed
       valid_lft forever preferred_lft forever
root@szx-iptables-2:/etc/squid/squid-reverse# ip a s br100
39: br100: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP
    link/ether 16:8d:bf:67:91:33 brd ff:ff:ff:ff:ff:ff
    inet 192.168.2.77/24 brd 192.168.2.255 scope global br100
    inet6 fe80::f816:3eff:fe0c:d6ea/64 scope link tentative dadfailed
       valid_lft forever preferred_lft forever

t@example5:~# ip r
default via 192.168.2.77 dev eth0
192.168.2.0/24 dev eth0  proto kernel  scope link  src 192.168.2.78
root@example5:~# ip a s
48: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP q                       len 1000
    link/ether 00:ff:12:34:56:78 brd ff:ff:ff:ff:ff:ff
    inet 192.168.2.78/24 brd 192.168.2.255 scope global eth0
    inet6 fe80::2ff:12ff:fe34:5678/64 scope link
       valid_lft forever preferred_lft forever
50: lo: <LOOPBACK,UP,LOWER_UP> mtu 16436 qdisc noqueue state UNKNOWN
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
root@example5:~# curl 'http://10.160.30.97'
<html><body><h1>It works!</h1>
<p>This is the default web page for this server.</p>
<p>The web server software is running but no content has been added, yet.</p>
</body></html>

