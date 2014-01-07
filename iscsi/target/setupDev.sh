#!/bin/bash

for i in  `seq 8`
do
    losetup  -d /dev/loop$((i-1))
    dd if=/dev/zero of=loop$((i-1)).img bs=1024k count=100
    losetup /dev/loop$((i-1)) loop$((i-1)).img
    blockdev --getsz /dev/loop$((i-1))
done

