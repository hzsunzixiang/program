#!/bin/bash
flag=123
iqn=com.netease1_$flag
blockName=block_$flag
lun=lun_$flag
#InitiatorName=iqn.1993-08.org.debian:01:fcc9228c36cc
InitiatorName=iqn.1993-08.org.debian:01:5c487996fda5
echo $iqn $blockName    $lun >info
tcm_node --block iblock_0/$blockName /dev/loop0
lio_node --addlun $iqn 1 0 $lun  iblock_0/$blockName
lio_node --listendpoints
lio_node --addnp $iqn 1  0.0.0.0:3260
lio_node --enableauth $iqn 1
lio_node --addlunacl $iqn 1 $InitiatorName 0 0
lio_node --setchapauth $iqn 1 $InitiatorName nbs 2013
lio_node --settpgattr=$iqn 1 cache_dynamic_acls 0

lio_node --enabletpg $iqn 1
lio_node --settpgattr=$iqn  1 demo_mode_write_protect 0





