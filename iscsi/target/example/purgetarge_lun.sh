#!/bin/bash

device=$1
lio_node --deltpg test:123456:${device} 1 
tcm_node --freedev iblock_0/test_${device} 
lio_node --deliqn=test:123456:${device} 
