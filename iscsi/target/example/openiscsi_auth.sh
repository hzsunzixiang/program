#!/bin/bash
tcm_node --block iblock_0/test_loop0 /dev/loop0 
lio_node --addlun test:123456:loop0 1 0 iscsi00 iblock_0/test_loop0 
lio_node --addnp test:123456:loop0 1 0.0.0.0:3260 
lio_node --enableauth test:123456:loop0 1 
lio_node --addlunacl test:123456:loop0 1 iqn.1993-08.org.debian:01:fcc9228c36cc 0 0 
lio_node --setchapauth test:123456:loop0 1 iqn.1993-08.org.debian:01:fcc9228c36cc nbs netease 
lio_node --settpgattr=test:123456:loop0 1 cache_dynamic_acls 0 
lio_node --enabletpg test:123456:loop0 1 
