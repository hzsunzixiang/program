#/bin/bash

device=$1
iscsiadm -m node -T test:123456:${device} -p 192.168.146.233:3260 -l 
#iscsiadm -m node -T test:123456:${device} --logout 
