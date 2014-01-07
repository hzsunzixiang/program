#!/bin/bash

iscsiadm -m discovery -t st -p 192.168.146.233:3260 
iscsiadm -m node -T test:123456:loop0 --op=update --name=node.session.auth.authmethod --value=CHAP 
iscsiadm -m node -T test:123456:loop0 --op=update --name=node.session.auth.username --value=nbs 
iscsiadm -m node -T test:123456:loop0 --op=update --name=node.session.auth.password --value=netease 
iscsiadm -m node -T test:123456:loop0 -p 192.168.146.233:3260 -l 
