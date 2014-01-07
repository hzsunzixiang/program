#!/bin/bash
#iqn=com.netease1`date '+%s'`
#blockName=block_`date '+%s'`
#lun=lun_`date '+%s'`
flag=123
iqn=com.netease1_$flag
blockName=block_$flag
lun=lun_$flag
InitiatorName=iqn.1993-08.org.debian:01:fcc9228c36cc
echo $iqn $blockName    $lun >info
#tcm_node --block iblock_0/$blockName /dev/loop0
#lio_node --addlun $iqn 1 0 $lun  iblock_0/$blockName
#lio_node --listendpoints
#lio_node --addnp $iqn 1  0.0.0.0:3260
lio_node --enableauth $iqn 1
lio_node --addlunacl $iqn 1 $InitiatorName 0 0
lio_node --setchapauth $iqn 1 $InitiatorName nbs 2013
lio_node --settpgattr=$iqn 1 cache_dynamic_acls 0
lio_node --enabletpg $iqn 1
lio_node --settpgattr=$iqn  1 demo_mode_write_protect 0
iscsiadm -m session -P3
iscsiadm -m discovery -t sendtargets -p 192.168.146.26:3260

#iscsiadm -m discovery -t st -p 192.168.146.26:3260
#iscsiadm -m node -T  $iqn --op=update --name=node.session.auth.authmethod --value=CHAP
#iscsiadm -m node -T  $iqn --op=update --name=node.session.auth.username --value=nbs
#iscsiadm -m node -T  $iqn --op=update --name=node.session.auth.password --value=2013
#iscsiadm -m node -T  $iqn -p 192.168.146.26:3260 -l






