
root@szx-iptables-2:/etc/squid/squid-transparent# ip a  s br100
39: br100: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP
    link/ether 16:8d:bf:67:91:33 brd ff:ff:ff:ff:ff:ff
    inet 192.168.2.77/24 brd 192.168.2.255 scope global br100
    inet6 fe80::f816:3eff:fe0c:d6ea/64 scope link tentative dadfailed
       valid_lft forever preferred_lft forever
root@szx-iptables-2:/etc/squid/squid-transparent# ip a  s eth0
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
    link/ether fa:16:3e:0c:d6:ea brd ff:ff:ff:ff:ff:ff
    inet 10.160.30.97/23 brd 10.160.31.255 scope global eth0
    inet6 fe80::f816:3eff:fe0c:d6ea/64 scope link tentative dadfailed
       valid_lft forever preferred_lft forever
root@szx-iptables-2:/etc/squid/squid-transparent# ip r
default via 10.160.30.15 dev eth0
10.160.30.0/23 dev eth0  proto kernel  scope link  src 10.160.30.97
192.168.2.0/24 dev br100  proto kernel  scope link  src 192.168.2.77

root@szx-iptables-2:~# iptables -t nat -A POSTROUTING -s 192.168.2.0/24 -o eth0 -j MASQUERADE
root@szx-iptables-2:~# /sbin/iptables -t nat -A PREROUTING -s 192.168.2.0/24 -i br100  -p tcp --dport 80 -j REDIRECT --to-port 3128




