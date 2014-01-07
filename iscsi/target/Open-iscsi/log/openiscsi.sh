2013-06-03 19:55:19,317 DEBUG run ssh -i  ~/.ssh/key root@192.168.146.233 "python /root/program/iscsi/Open-iscsi/lib/sendtarget.py send loop0" 
2013-06-03 19:55:22,680 INFO Call interface sendTarget(loop0, iqn.1993-08.org.debian:01:fcc9228c36cc)...
2013-06-03 19:55:22,680 DEBUG run tcm_node --block iblock_0/test_loop0 /dev/loop0 
2013-06-03 19:55:23,157 DEBUG run lio_node --addlun test:123456:loop0 1 0 iscsi00 iblock_0/test_loop0 
2013-06-03 19:55:23,366 DEBUG run lio_node --addnp test:123456:loop0 1 0.0.0.0:3260 
2013-06-03 19:55:23,432 DEBUG run lio_node --enableauth test:123456:loop0 1 
2013-06-03 19:55:23,491 DEBUG run lio_node --addlunacl test:123456:loop0 1 iqn.1993-08.org.debian:01:fcc9228c36cc 0 0 
2013-06-03 19:55:23,559 DEBUG run lio_node --setchapauth test:123456:loop0 1 iqn.1993-08.org.debian:01:fcc9228c36cc nbs netease 
2013-06-03 19:55:23,621 DEBUG run lio_node --settpgattr=test:123456:loop0 1 cache_dynamic_acls 0 
2013-06-03 19:55:23,672 DEBUG run lio_node --enabletpg test:123456:loop0 1 
2013-06-03 19:55:23,730 INFO sendTarget success
2013-06-03 19:55:23,731 DEBUG sendTarget success
2013-06-03 19:55:23,749 DEBUG run iscsiadm -m discovery -t st -p 192.168.146.233:3260 
2013-06-03 19:55:23,840 DEBUG run iscsiadm -m node -T test:123456:loop0 --op=update --name=node.session.auth.authmethod --value=CHAP 
2013-06-03 19:55:23,852 DEBUG run iscsiadm -m node -T test:123456:loop0 --op=update --name=node.session.auth.username --value=nbs 
2013-06-03 19:55:23,865 DEBUG run iscsiadm -m node -T test:123456:loop0 --op=update --name=node.session.auth.password --value=netease 
2013-06-03 19:55:23,877 DEBUG run iscsiadm -m node -T test:123456:loop0 -p 192.168.146.233:3260 -l 
2013-06-03 19:55:27,168 DEBUG run iscsiadm -m node -T test:123456:loop0 --logout 
2013-06-03 19:55:27,703 DEBUG run ssh -i  ~/.ssh/key root@192.168.146.233 "python /root/program/iscsi/Open-iscsi/lib/sendtarget.py purge loop0" 
2013-06-03 19:55:28,379 DEBUG run lio_node --deltpg test:123456:loop0 1 
2013-06-03 19:55:28,473 INFO purgeIqn success
2013-06-03 19:55:28,474 DEBUG run tcm_node --freedev iblock_0/test_loop0 
2013-06-03 19:55:28,558 DEBUG purgeTcm success
2013-06-03 19:55:28,558 DEBUG run lio_node --deliqn=test:123456:loop0 
2013-06-03 19:55:28,617 DEBUG purgeIscsi success
2013-06-03 19:55:28,618 DEBUG purgeTarget success
2013-06-03 19:55:28,637 DEBUG run ssh -i  ~/.ssh/key root@192.168.146.233 "python /root/program/iscsi/Open-iscsi/lib/sendtarget.py send loop0" 
2013-06-03 19:55:29,320 INFO Call interface sendTarget(loop0, iqn.1993-08.org.debian:01:fcc9228c36cc)...
2013-06-03 19:55:29,320 DEBUG run tcm_node --block iblock_0/test_loop0 /dev/loop0 
2013-06-03 19:55:29,420 DEBUG run lio_node --addlun test:123456:loop0 1 0 iscsi00 iblock_0/test_loop0 
2013-06-03 19:55:29,489 DEBUG run lio_node --addnp test:123456:loop0 1 0.0.0.0:3260 
2013-06-03 19:55:29,550 DEBUG run lio_node --enableauth test:123456:loop0 1 
2013-06-03 19:55:29,606 DEBUG run lio_node --addlunacl test:123456:loop0 1 iqn.1993-08.org.debian:01:fcc9228c36cc 0 0 
2013-06-03 19:55:29,671 DEBUG run lio_node --setchapauth test:123456:loop0 1 iqn.1993-08.org.debian:01:fcc9228c36cc nbs netease 
2013-06-03 19:55:29,731 DEBUG run lio_node --settpgattr=test:123456:loop0 1 cache_dynamic_acls 0 
2013-06-03 19:55:29,782 DEBUG run lio_node --enabletpg test:123456:loop0 1 
2013-06-03 19:55:29,841 INFO sendTarget success
2013-06-03 19:55:29,842 DEBUG sendTarget success
2013-06-03 19:55:29,861 DEBUG run iscsiadm -m discovery -t st -p 192.168.146.233:3260 
2013-06-03 19:55:29,887 DEBUG run iscsiadm -m node -T test:123456:loop0 --op=update --name=node.session.auth.authmethod --value=CHAP 
2013-06-03 19:55:29,905 DEBUG run iscsiadm -m node -T test:123456:loop0 --op=update --name=node.session.auth.username --value=nbs 
2013-06-03 19:55:29,917 DEBUG run iscsiadm -m node -T test:123456:loop0 --op=update --name=node.session.auth.password --value=netease 
2013-06-03 19:55:29,930 DEBUG run iscsiadm -m node -T test:123456:loop0 -p 192.168.146.233:3260 -l 
2013-06-03 19:55:33,245 DEBUG run iscsiadm -m node -T test:123456:loop0 --logout 
2013-06-03 19:55:33,783 DEBUG run ssh -i  ~/.ssh/key root@192.168.146.233 "python /root/program/iscsi/Open-iscsi/lib/sendtarget.py purge loop0" 
2013-06-03 19:55:34,455 DEBUG run lio_node --deltpg test:123456:loop0 1 
2013-06-03 19:55:34,544 INFO purgeIqn success
2013-06-03 19:55:34,545 DEBUG run tcm_node --freedev iblock_0/test_loop0 
2013-06-03 19:55:34,617 DEBUG purgeTcm success
2013-06-03 19:55:34,618 DEBUG run lio_node --deliqn=test:123456:loop0 
2013-06-03 19:55:34,677 DEBUG purgeIscsi success
2013-06-03 19:55:34,678 DEBUG purgeTarget success
2013-06-03 19:55:34,698 DEBUG run ssh -i  ~/.ssh/key root@192.168.146.233 "python /root/program/iscsi/Open-iscsi/lib/sendtarget.py send loop0" 
2013-06-03 19:55:35,383 INFO Call interface sendTarget(loop0, iqn.1993-08.org.debian:01:fcc9228c36cc)...
2013-06-03 19:55:35,385 DEBUG run tcm_node --block iblock_0/test_loop0 /dev/loop0 
2013-06-03 19:55:35,481 DEBUG run lio_node --addlun test:123456:loop0 1 0 iscsi00 iblock_0/test_loop0 
2013-06-03 19:55:35,550 DEBUG run lio_node --addnp test:123456:loop0 1 0.0.0.0:3260 
2013-06-03 19:55:35,609 DEBUG run lio_node --enableauth test:123456:loop0 1 
2013-06-03 19:55:35,665 DEBUG run lio_node --addlunacl test:123456:loop0 1 iqn.1993-08.org.debian:01:fcc9228c36cc 0 0 
2013-06-03 19:55:35,729 DEBUG run lio_node --setchapauth test:123456:loop0 1 iqn.1993-08.org.debian:01:fcc9228c36cc nbs netease 
2013-06-03 19:55:35,788 DEBUG run lio_node --settpgattr=test:123456:loop0 1 cache_dynamic_acls 0 
2013-06-03 19:55:35,838 DEBUG run lio_node --enabletpg test:123456:loop0 1 
2013-06-03 19:55:35,897 INFO sendTarget success
2013-06-03 19:55:35,897 DEBUG sendTarget success
2013-06-03 19:55:35,917 DEBUG run iscsiadm -m discovery -t st -p 192.168.146.233:3260 
2013-06-03 19:55:35,943 DEBUG run iscsiadm -m node -T test:123456:loop0 --op=update --name=node.session.auth.authmethod --value=CHAP 
2013-06-03 19:55:35,959 DEBUG run iscsiadm -m node -T test:123456:loop0 --op=update --name=node.session.auth.username --value=nbs 
2013-06-03 19:55:35,972 DEBUG run iscsiadm -m node -T test:123456:loop0 --op=update --name=node.session.auth.password --value=netease 
2013-06-03 19:55:35,985 DEBUG run iscsiadm -m node -T test:123456:loop0 -p 192.168.146.233:3260 -l 
2013-06-03 19:55:39,296 DEBUG run iscsiadm -m node -T test:123456:loop0 --logout 
2013-06-03 19:55:39,834 DEBUG run ssh -i  ~/.ssh/key root@192.168.146.233 "python /root/program/iscsi/Open-iscsi/lib/sendtarget.py purge loop0" 
2013-06-03 19:55:40,492 DEBUG run lio_node --deltpg test:123456:loop0 1 
2013-06-03 19:55:40,577 INFO purgeIqn success
2013-06-03 19:55:40,578 DEBUG run tcm_node --freedev iblock_0/test_loop0 
2013-06-03 19:55:40,651 DEBUG purgeTcm success
2013-06-03 19:55:40,652 DEBUG run lio_node --deliqn=test:123456:loop0 
2013-06-03 19:55:40,709 DEBUG purgeIscsi success
2013-06-03 19:55:40,710 DEBUG purgeTarget success
2013-06-03 19:55:40,730 DEBUG run ssh -i  ~/.ssh/key root@192.168.146.233 "python /root/program/iscsi/Open-iscsi/lib/sendtarget.py send loop0" 
2013-06-03 19:55:41,404 INFO Call interface sendTarget(loop0, iqn.1993-08.org.debian:01:fcc9228c36cc)...
2013-06-03 19:55:41,404 DEBUG run tcm_node --block iblock_0/test_loop0 /dev/loop0 
2013-06-03 19:55:41,499 DEBUG run lio_node --addlun test:123456:loop0 1 0 iscsi00 iblock_0/test_loop0 
2013-06-03 19:55:41,568 DEBUG run lio_node --addnp test:123456:loop0 1 0.0.0.0:3260 
2013-06-03 19:55:41,627 DEBUG run lio_node --enableauth test:123456:loop0 1 
2013-06-03 19:55:41,684 DEBUG run lio_node --addlunacl test:123456:loop0 1 iqn.1993-08.org.debian:01:fcc9228c36cc 0 0 
2013-06-03 19:55:41,752 DEBUG run lio_node --setchapauth test:123456:loop0 1 iqn.1993-08.org.debian:01:fcc9228c36cc nbs netease 
2013-06-03 19:55:41,813 DEBUG run lio_node --settpgattr=test:123456:loop0 1 cache_dynamic_acls 0 
2013-06-03 19:55:41,864 DEBUG run lio_node --enabletpg test:123456:loop0 1 
2013-06-03 19:55:41,920 INFO sendTarget success
2013-06-03 19:55:41,922 DEBUG sendTarget success
2013-06-03 19:55:41,940 DEBUG run iscsiadm -m discovery -t st -p 192.168.146.233:3260 
2013-06-03 19:55:41,966 DEBUG run iscsiadm -m node -T test:123456:loop0 --op=update --name=node.session.auth.authmethod --value=CHAP 
2013-06-03 19:55:41,985 DEBUG run iscsiadm -m node -T test:123456:loop0 --op=update --name=node.session.auth.username --value=nbs 
2013-06-03 19:55:42,003 DEBUG run iscsiadm -m node -T test:123456:loop0 --op=update --name=node.session.auth.password --value=netease 
2013-06-03 19:55:42,037 DEBUG run iscsiadm -m node -T test:123456:loop0 -p 192.168.146.233:3260 -l 
2013-06-03 19:55:45,350 DEBUG run iscsiadm -m node -T test:123456:loop0 --logout 
2013-06-03 19:55:45,890 DEBUG run ssh -i  ~/.ssh/key root@192.168.146.233 "python /root/program/iscsi/Open-iscsi/lib/sendtarget.py purge loop0" 
2013-06-03 19:55:46,544 DEBUG run lio_node --deltpg test:123456:loop0 1 
2013-06-03 19:55:46,632 INFO purgeIqn success
2013-06-03 19:55:46,632 DEBUG run tcm_node --freedev iblock_0/test_loop0 
2013-06-03 19:55:46,705 DEBUG purgeTcm success
2013-06-03 19:55:46,706 DEBUG run lio_node --deliqn=test:123456:loop0 
2013-06-03 19:55:46,763 DEBUG purgeIscsi success
2013-06-03 19:55:46,763 DEBUG purgeTarget success
2013-06-03 19:55:46,782 DEBUG run ssh -i  ~/.ssh/key root@192.168.146.233 "python /root/program/iscsi/Open-iscsi/lib/sendtarget.py send loop0" 
2013-06-03 19:55:47,470 INFO Call interface sendTarget(loop0, iqn.1993-08.org.debian:01:fcc9228c36cc)...
2013-06-03 19:55:47,470 DEBUG run tcm_node --block iblock_0/test_loop0 /dev/loop0 
2013-06-03 19:55:47,566 DEBUG run lio_node --addlun test:123456:loop0 1 0 iscsi00 iblock_0/test_loop0 
2013-06-03 19:55:47,635 DEBUG run lio_node --addnp test:123456:loop0 1 0.0.0.0:3260 
2013-06-03 19:55:47,695 DEBUG run lio_node --enableauth test:123456:loop0 1 
2013-06-03 19:55:47,751 DEBUG run lio_node --addlunacl test:123456:loop0 1 iqn.1993-08.org.debian:01:fcc9228c36cc 0 0 
2013-06-03 19:55:47,814 DEBUG run lio_node --setchapauth test:123456:loop0 1 iqn.1993-08.org.debian:01:fcc9228c36cc nbs netease 
2013-06-03 19:55:47,873 DEBUG run lio_node --settpgattr=test:123456:loop0 1 cache_dynamic_acls 0 
2013-06-03 19:55:47,924 DEBUG run lio_node --enabletpg test:123456:loop0 1 
2013-06-03 19:55:47,982 INFO sendTarget success
2013-06-03 19:55:47,983 DEBUG sendTarget success
2013-06-03 19:55:48,003 DEBUG run iscsiadm -m discovery -t st -p 192.168.146.233:3260 
2013-06-03 19:55:48,030 DEBUG run iscsiadm -m node -T test:123456:loop0 --op=update --name=node.session.auth.authmethod --value=CHAP 
2013-06-03 19:55:48,044 DEBUG run iscsiadm -m node -T test:123456:loop0 --op=update --name=node.session.auth.username --value=nbs 
2013-06-03 19:55:48,064 DEBUG run iscsiadm -m node -T test:123456:loop0 --op=update --name=node.session.auth.password --value=netease 
2013-06-03 19:55:48,079 DEBUG run iscsiadm -m node -T test:123456:loop0 -p 192.168.146.233:3260 -l 
2013-06-03 19:55:51,390 DEBUG run iscsiadm -m node -T test:123456:loop0 --logout 
2013-06-03 19:55:51,929 DEBUG run ssh -i  ~/.ssh/key root@192.168.146.233 "python /root/program/iscsi/Open-iscsi/lib/sendtarget.py purge loop0" 
2013-06-03 19:55:52,610 DEBUG run lio_node --deltpg test:123456:loop0 1 
2013-06-03 19:55:52,698 INFO purgeIqn success
2013-06-03 19:55:52,699 DEBUG run tcm_node --freedev iblock_0/test_loop0 
2013-06-03 19:55:52,771 DEBUG purgeTcm success
2013-06-03 19:55:52,772 DEBUG run lio_node --deliqn=test:123456:loop0 
2013-06-03 19:55:52,829 DEBUG purgeIscsi success
2013-06-03 19:55:52,830 DEBUG purgeTarget success
2013-06-03 19:55:52,850 DEBUG run ssh -i  ~/.ssh/key root@192.168.146.233 "python /root/program/iscsi/Open-iscsi/lib/sendtarget.py send loop0" 
2013-06-03 19:55:53,539 INFO Call interface sendTarget(loop0, iqn.1993-08.org.debian:01:fcc9228c36cc)...
2013-06-03 19:55:53,539 DEBUG run tcm_node --block iblock_0/test_loop0 /dev/loop0 
2013-06-03 19:55:53,635 DEBUG run lio_node --addlun test:123456:loop0 1 0 iscsi00 iblock_0/test_loop0 
2013-06-03 19:55:53,706 DEBUG run lio_node --addnp test:123456:loop0 1 0.0.0.0:3260 
2013-06-03 19:55:53,764 DEBUG run lio_node --enableauth test:123456:loop0 1 
2013-06-03 19:55:53,822 DEBUG run lio_node --addlunacl test:123456:loop0 1 iqn.1993-08.org.debian:01:fcc9228c36cc 0 0 
2013-06-03 19:55:53,884 DEBUG run lio_node --setchapauth test:123456:loop0 1 iqn.1993-08.org.debian:01:fcc9228c36cc nbs netease 
2013-06-03 19:55:53,944 DEBUG run lio_node --settpgattr=test:123456:loop0 1 cache_dynamic_acls 0 
2013-06-03 19:55:53,995 DEBUG run lio_node --enabletpg test:123456:loop0 1 
2013-06-03 19:55:54,055 INFO sendTarget success
2013-06-03 19:55:54,056 DEBUG sendTarget success
2013-06-03 19:55:54,078 DEBUG run iscsiadm -m discovery -t st -p 192.168.146.233:3260 
2013-06-03 19:55:54,104 DEBUG run iscsiadm -m node -T test:123456:loop0 --op=update --name=node.session.auth.authmethod --value=CHAP 
2013-06-03 19:55:54,121 DEBUG run iscsiadm -m node -T test:123456:loop0 --op=update --name=node.session.auth.username --value=nbs 
2013-06-03 19:55:54,139 DEBUG run iscsiadm -m node -T test:123456:loop0 --op=update --name=node.session.auth.password --value=netease 
2013-06-03 19:55:54,177 DEBUG run iscsiadm -m node -T test:123456:loop0 -p 192.168.146.233:3260 -l 
2013-06-03 19:55:57,472 DEBUG run iscsiadm -m node -T test:123456:loop0 --logout 
2013-06-03 19:55:58,011 DEBUG run ssh -i  ~/.ssh/key root@192.168.146.233 "python /root/program/iscsi/Open-iscsi/lib/sendtarget.py purge loop0" 
2013-06-03 19:55:58,665 DEBUG run lio_node --deltpg test:123456:loop0 1 
2013-06-03 19:55:58,753 INFO purgeIqn success
2013-06-03 19:55:58,754 DEBUG run tcm_node --freedev iblock_0/test_loop0 
2013-06-03 19:55:58,826 DEBUG purgeTcm success
2013-06-03 19:55:58,826 DEBUG run lio_node --deliqn=test:123456:loop0 
2013-06-03 19:55:58,886 DEBUG purgeIscsi success
2013-06-03 19:55:58,886 DEBUG purgeTarget success
2013-06-03 19:55:58,906 DEBUG run ssh -i  ~/.ssh/key root@192.168.146.233 "python /root/program/iscsi/Open-iscsi/lib/sendtarget.py send loop0" 
2013-06-03 19:55:59,588 INFO Call interface sendTarget(loop0, iqn.1993-08.org.debian:01:fcc9228c36cc)...
2013-06-03 19:55:59,589 DEBUG run tcm_node --block iblock_0/test_loop0 /dev/loop0 
2013-06-03 19:55:59,684 DEBUG run lio_node --addlun test:123456:loop0 1 0 iscsi00 iblock_0/test_loop0 
2013-06-03 19:55:59,755 DEBUG run lio_node --addnp test:123456:loop0 1 0.0.0.0:3260 
2013-06-03 19:55:59,813 DEBUG run lio_node --enableauth test:123456:loop0 1 
2013-06-03 19:55:59,869 DEBUG run lio_node --addlunacl test:123456:loop0 1 iqn.1993-08.org.debian:01:fcc9228c36cc 0 0 
2013-06-03 19:55:59,935 DEBUG run lio_node --setchapauth test:123456:loop0 1 iqn.1993-08.org.debian:01:fcc9228c36cc nbs netease 
2013-06-03 19:55:59,999 DEBUG run lio_node --settpgattr=test:123456:loop0 1 cache_dynamic_acls 0 
2013-06-03 19:56:00,052 DEBUG run lio_node --enabletpg test:123456:loop0 1 
2013-06-03 19:56:00,109 INFO sendTarget success
2013-06-03 19:56:00,110 DEBUG sendTarget success
2013-06-03 19:56:00,131 DEBUG run iscsiadm -m discovery -t st -p 192.168.146.233:3260 
2013-06-03 19:56:00,154 DEBUG run iscsiadm -m node -T test:123456:loop0 --op=update --name=node.session.auth.authmethod --value=CHAP 
2013-06-03 19:56:00,182 DEBUG run iscsiadm -m node -T test:123456:loop0 --op=update --name=node.session.auth.username --value=nbs 
2013-06-03 19:56:00,208 DEBUG run iscsiadm -m node -T test:123456:loop0 --op=update --name=node.session.auth.password --value=netease 
2013-06-03 19:56:00,230 DEBUG run iscsiadm -m node -T test:123456:loop0 -p 192.168.146.233:3260 -l 
2013-06-03 19:56:03,536 DEBUG run iscsiadm -m node -T test:123456:loop0 --logout 
2013-06-03 19:56:04,074 DEBUG run ssh -i  ~/.ssh/key root@192.168.146.233 "python /root/program/iscsi/Open-iscsi/lib/sendtarget.py purge loop0" 
2013-06-03 19:56:04,716 DEBUG run lio_node --deltpg test:123456:loop0 1 
2013-06-03 19:56:04,804 INFO purgeIqn success
2013-06-03 19:56:04,805 DEBUG run tcm_node --freedev iblock_0/test_loop0 
2013-06-03 19:56:04,877 DEBUG purgeTcm success
2013-06-03 19:56:04,878 DEBUG run lio_node --deliqn=test:123456:loop0 
2013-06-03 19:56:04,936 DEBUG purgeIscsi success
2013-06-03 19:56:04,936 DEBUG purgeTarget success
2013-06-03 19:56:04,957 DEBUG run ssh -i  ~/.ssh/key root@192.168.146.233 "python /root/program/iscsi/Open-iscsi/lib/sendtarget.py send loop0" 
2013-06-03 19:56:05,620 INFO Call interface sendTarget(loop0, iqn.1993-08.org.debian:01:fcc9228c36cc)...
2013-06-03 19:56:05,621 DEBUG run tcm_node --block iblock_0/test_loop0 /dev/loop0 
2013-06-03 19:56:05,717 DEBUG run lio_node --addlun test:123456:loop0 1 0 iscsi00 iblock_0/test_loop0 
2013-06-03 19:56:05,785 DEBUG run lio_node --addnp test:123456:loop0 1 0.0.0.0:3260 
2013-06-03 19:56:05,844 DEBUG run lio_node --enableauth test:123456:loop0 1 
2013-06-03 19:56:05,900 DEBUG run lio_node --addlunacl test:123456:loop0 1 iqn.1993-08.org.debian:01:fcc9228c36cc 0 0 
2013-06-03 19:56:05,963 DEBUG run lio_node --setchapauth test:123456:loop0 1 iqn.1993-08.org.debian:01:fcc9228c36cc nbs netease 
2013-06-03 19:56:06,022 DEBUG run lio_node --settpgattr=test:123456:loop0 1 cache_dynamic_acls 0 
2013-06-03 19:56:06,075 DEBUG run lio_node --enabletpg test:123456:loop0 1 
2013-06-03 19:56:06,133 INFO sendTarget success
2013-06-03 19:56:06,133 DEBUG sendTarget success
2013-06-03 19:56:06,153 DEBUG run iscsiadm -m discovery -t st -p 192.168.146.233:3260 
2013-06-03 19:56:06,200 DEBUG run iscsiadm -m node -T test:123456:loop0 --op=update --name=node.session.auth.authmethod --value=CHAP 
2013-06-03 19:56:06,217 DEBUG run iscsiadm -m node -T test:123456:loop0 --op=update --name=node.session.auth.username --value=nbs 
2013-06-03 19:56:06,235 DEBUG run iscsiadm -m node -T test:123456:loop0 --op=update --name=node.session.auth.password --value=netease 
2013-06-03 19:56:06,248 DEBUG run iscsiadm -m node -T test:123456:loop0 -p 192.168.146.233:3260 -l 
2013-06-03 19:56:09,557 DEBUG run iscsiadm -m node -T test:123456:loop0 --logout 
2013-06-03 19:56:10,100 DEBUG run ssh -i  ~/.ssh/key root@192.168.146.233 "python /root/program/iscsi/Open-iscsi/lib/sendtarget.py purge loop0" 
2013-06-03 19:56:10,741 DEBUG run lio_node --deltpg test:123456:loop0 1 
2013-06-03 19:56:10,830 INFO purgeIqn success
2013-06-03 19:56:10,831 DEBUG run tcm_node --freedev iblock_0/test_loop0 
2013-06-03 19:56:10,905 DEBUG purgeTcm success
2013-06-03 19:56:10,906 DEBUG run lio_node --deliqn=test:123456:loop0 
2013-06-03 19:56:10,964 DEBUG purgeIscsi success
2013-06-03 19:56:10,964 DEBUG purgeTarget success
2013-06-03 19:56:10,986 DEBUG run ssh -i  ~/.ssh/key root@192.168.146.233 "python /root/program/iscsi/Open-iscsi/lib/sendtarget.py send loop0" 
2013-06-03 19:56:11,668 INFO Call interface sendTarget(loop0, iqn.1993-08.org.debian:01:fcc9228c36cc)...
2013-06-03 19:56:11,669 DEBUG run tcm_node --block iblock_0/test_loop0 /dev/loop0 
2013-06-03 19:56:11,766 DEBUG run lio_node --addlun test:123456:loop0 1 0 iscsi00 iblock_0/test_loop0 
2013-06-03 19:56:11,836 DEBUG run lio_node --addnp test:123456:loop0 1 0.0.0.0:3260 
2013-06-03 19:56:11,898 DEBUG run lio_node --enableauth test:123456:loop0 1 
2013-06-03 19:56:11,958 DEBUG run lio_node --addlunacl test:123456:loop0 1 iqn.1993-08.org.debian:01:fcc9228c36cc 0 0 
2013-06-03 19:56:12,022 DEBUG run lio_node --setchapauth test:123456:loop0 1 iqn.1993-08.org.debian:01:fcc9228c36cc nbs netease 
2013-06-03 19:56:12,083 DEBUG run lio_node --settpgattr=test:123456:loop0 1 cache_dynamic_acls 0 
2013-06-03 19:56:12,134 DEBUG run lio_node --enabletpg test:123456:loop0 1 
2013-06-03 19:56:12,212 INFO sendTarget success
2013-06-03 19:56:12,213 DEBUG sendTarget success
2013-06-03 19:56:12,232 DEBUG run iscsiadm -m discovery -t st -p 192.168.146.233:3260 
2013-06-03 19:56:12,257 DEBUG run iscsiadm -m node -T test:123456:loop0 --op=update --name=node.session.auth.authmethod --value=CHAP 
2013-06-03 19:56:12,276 DEBUG run iscsiadm -m node -T test:123456:loop0 --op=update --name=node.session.auth.username --value=nbs 
2013-06-03 19:56:12,291 DEBUG run iscsiadm -m node -T test:123456:loop0 --op=update --name=node.session.auth.password --value=netease 
2013-06-03 19:56:12,304 DEBUG run iscsiadm -m node -T test:123456:loop0 -p 192.168.146.233:3260 -l 
2013-06-03 19:56:15,612 DEBUG run iscsiadm -m node -T test:123456:loop0 --logout 
2013-06-03 19:56:16,153 DEBUG run ssh -i  ~/.ssh/key root@192.168.146.233 "python /root/program/iscsi/Open-iscsi/lib/sendtarget.py purge loop0" 
2013-06-03 19:56:16,862 DEBUG run lio_node --deltpg test:123456:loop0 1 
2013-06-03 19:56:16,974 INFO purgeIqn success
2013-06-03 19:56:16,975 DEBUG run tcm_node --freedev iblock_0/test_loop0 
2013-06-03 19:56:17,084 DEBUG purgeTcm success
2013-06-03 19:56:17,085 DEBUG run lio_node --deliqn=test:123456:loop0 
2013-06-03 19:56:17,178 DEBUG purgeIscsi success
2013-06-03 19:56:17,178 DEBUG purgeTarget success
2013-06-03 19:56:17,212 DEBUG run ssh -i  ~/.ssh/key root@192.168.146.233 "python /root/program/iscsi/Open-iscsi/lib/sendtarget.py send loop0" 
2013-06-03 19:56:17,881 INFO Call interface sendTarget(loop0, iqn.1993-08.org.debian:01:fcc9228c36cc)...
2013-06-03 19:56:17,881 DEBUG run tcm_node --block iblock_0/test_loop0 /dev/loop0 
2013-06-03 19:56:17,978 DEBUG run lio_node --addlun test:123456:loop0 1 0 iscsi00 iblock_0/test_loop0 
2013-06-03 19:56:18,049 DEBUG run lio_node --addnp test:123456:loop0 1 0.0.0.0:3260 
2013-06-03 19:56:18,109 DEBUG run lio_node --enableauth test:123456:loop0 1 
2013-06-03 19:56:18,166 DEBUG run lio_node --addlunacl test:123456:loop0 1 iqn.1993-08.org.debian:01:fcc9228c36cc 0 0 
2013-06-03 19:56:18,248 DEBUG run lio_node --setchapauth test:123456:loop0 1 iqn.1993-08.org.debian:01:fcc9228c36cc nbs netease 
2013-06-03 19:56:18,309 DEBUG run lio_node --settpgattr=test:123456:loop0 1 cache_dynamic_acls 0 
2013-06-03 19:56:18,363 DEBUG run lio_node --enabletpg test:123456:loop0 1 
2013-06-03 19:56:18,430 INFO sendTarget success
2013-06-03 19:56:18,431 DEBUG sendTarget success
2013-06-03 19:56:18,453 DEBUG run iscsiadm -m discovery -t st -p 192.168.146.233:3260 
2013-06-03 19:56:18,478 DEBUG run iscsiadm -m node -T test:123456:loop0 --op=update --name=node.session.auth.authmethod --value=CHAP 
2013-06-03 19:56:18,494 DEBUG run iscsiadm -m node -T test:123456:loop0 --op=update --name=node.session.auth.username --value=nbs 
2013-06-03 19:56:18,511 DEBUG run iscsiadm -m node -T test:123456:loop0 --op=update --name=node.session.auth.password --value=netease 
2013-06-03 19:56:18,525 DEBUG run iscsiadm -m node -T test:123456:loop0 -p 192.168.146.233:3260 -l 
2013-06-03 19:56:21,837 DEBUG run iscsiadm -m node -T test:123456:loop0 --logout 
2013-06-03 19:56:22,375 DEBUG run ssh -i  ~/.ssh/key root@192.168.146.233 "python /root/program/iscsi/Open-iscsi/lib/sendtarget.py purge loop0" 
2013-06-03 19:56:22,999 DEBUG run lio_node --deltpg test:123456:loop0 1 
2013-06-03 19:56:23,088 INFO purgeIqn success
2013-06-03 19:56:23,089 DEBUG run tcm_node --freedev iblock_0/test_loop0 
2013-06-03 19:56:23,165 DEBUG purgeTcm success
2013-06-03 19:56:23,166 DEBUG run lio_node --deliqn=test:123456:loop0 
2013-06-03 19:56:23,241 DEBUG purgeIscsi success
2013-06-03 19:56:23,242 DEBUG purgeTarget success
2013-06-03 19:56:23,265 DEBUG run ssh -i  ~/.ssh/key root@192.168.146.233 "python /root/program/iscsi/Open-iscsi/lib/sendtarget.py send loop0" 
2013-06-03 19:56:23,911 INFO Call interface sendTarget(loop0, iqn.1993-08.org.debian:01:fcc9228c36cc)...
2013-06-03 19:56:23,912 DEBUG run tcm_node --block iblock_0/test_loop0 /dev/loop0 
2013-06-03 19:56:24,007 DEBUG run lio_node --addlun test:123456:loop0 1 0 iscsi00 iblock_0/test_loop0 
2013-06-03 19:56:24,079 DEBUG run lio_node --addnp test:123456:loop0 1 0.0.0.0:3260 
2013-06-03 19:56:24,140 DEBUG run lio_node --enableauth test:123456:loop0 1 
2013-06-03 19:56:24,198 DEBUG run lio_node --addlunacl test:123456:loop0 1 iqn.1993-08.org.debian:01:fcc9228c36cc 0 0 
2013-06-03 19:56:24,316 DEBUG run lio_node --setchapauth test:123456:loop0 1 iqn.1993-08.org.debian:01:fcc9228c36cc nbs netease 
2013-06-03 19:56:24,392 DEBUG run lio_node --settpgattr=test:123456:loop0 1 cache_dynamic_acls 0 
2013-06-03 19:56:24,465 DEBUG run lio_node --enabletpg test:123456:loop0 1 
2013-06-03 19:56:24,551 INFO sendTarget success
2013-06-03 19:56:24,552 DEBUG sendTarget success
2013-06-03 19:56:24,579 DEBUG run iscsiadm -m discovery -t st -p 192.168.146.233:3260 
2013-06-03 19:56:24,621 DEBUG run iscsiadm -m node -T test:123456:loop0 --op=update --name=node.session.auth.authmethod --value=CHAP 
2013-06-03 19:56:24,638 DEBUG run iscsiadm -m node -T test:123456:loop0 --op=update --name=node.session.auth.username --value=nbs 
2013-06-03 19:56:24,666 DEBUG run iscsiadm -m node -T test:123456:loop0 --op=update --name=node.session.auth.password --value=netease 
2013-06-03 19:56:24,681 DEBUG run iscsiadm -m node -T test:123456:loop0 -p 192.168.146.233:3260 -l 
2013-06-03 19:56:28,015 DEBUG run iscsiadm -m node -T test:123456:loop0 --logout 
2013-06-04 09:35:04,116 DEBUG run ssh -i  ~/.ssh/key root@192.168.146.233 "python /root/program/iscsi/Open-iscsi/lib/sendtarget.py send loop0" 
2013-06-04 09:35:11,840 DEBUG run ssh -i  ~/.ssh/key root@192.168.146.233 "python /root/program/iscsi/Open-iscsi/lib/sendtarget.py send send" 
2013-06-04 09:35:12,722 INFO Call interface sendTarget(send, iqn.1993-08.org.debian:01:fcc9228c36cc)...
2013-06-04 09:35:12,723 DEBUG run tcm_node --block iblock_0/test_send /dev/send 
2013-06-04 09:35:13,724 ERROR Traceback (most recent call last):
    File "/root/program/iscsi/Open-iscsi/lib/sendtarget.py", line 163, in sendTarget
      actionTcmCreate(rollback, ('test', lvName))
    File "/root/program/iscsi/Open-iscsi/lib/sendtarget.py", line 78, in actionTcmCreate
      runExec(osCmd)
    File "/root/program/iscsi/Open-iscsi/lib/iSCSIExec.py", line 18, in runExec
      raise Exception("Run cmd %s failed: \n errcode = %d, \n %s" % (cmd, errCode, errMsg))
  Exception: Run cmd tcm_node --block iblock_0/test_send /dev/send failed: 
   errcode = 1, 
   /bin/ls: cannot access /dev/send: No such file or directory
  Traceback (most recent call last):
    File "/usr/sbin/tcm_node", line 747, in <module>
      main()
    File "/usr/sbin/tcm_node", line 739, in main
      (options, args) = parser.parse_args()
    File "/usr/lib/python2.7/optparse.py", line 1399, in parse_args
      stop = self._process_args(largs, rargs, values)
    File "/usr/lib/python2.7/optparse.py", line 1439, in _process_args
      self._process_long_opt(rargs, values)
    File "/usr/lib/python2.7/optparse.py", line 1514, in _process_long_opt
      option.process(opt, value, values, self)
    File "/usr/lib/python2.7/optparse.py", line 788, in process
      self.action, self.dest, opt, value, values, parser)
    File "/usr/lib/python2.7/optparse.py", line 808, in take_action
      self.callback(self, opt, value, parser, *args, **kwargs)
    File "/usr/sbin/tcm_node", line 719, in dispatcher
      orig_callback(*value)
    File "/usr/sbin/tcm_node", line 305, in tcm_create_iblock
      tcm_createvirtdev(dev_path, udev_path)
    File "/usr/sbin/tcm_node", line 223, in tcm_createvirtdev
      tcm["module"].createvirtdev(dev_path, [plugin_params])
    File "/usr/share/pyshared/tcm_iblock.py", line 25, in createvirtdev
      major = out[4]
  IndexError: list index out of range
  
  
2013-06-04 09:35:13,726 INFO purgeIqn success
2013-06-04 09:35:13,726 DEBUG purgeTcm success
2013-06-04 09:35:13,726 DEBUG purgeIscsi success
2013-06-04 09:35:13,727 INFO Call interface sendTarget(send, iqn.1993-08.org.debian:01:fcc9228c36cc)...
2013-06-04 09:35:13,727 DEBUG run tcm_node --block iblock_0/test_send /dev/send 
2013-06-04 09:35:13,863 ERROR Traceback (most recent call last):
    File "/root/program/iscsi/Open-iscsi/lib/sendtarget.py", line 163, in sendTarget
      actionTcmCreate(rollback, ('test', lvName))
    File "/root/program/iscsi/Open-iscsi/lib/sendtarget.py", line 78, in actionTcmCreate
      runExec(osCmd)
    File "/root/program/iscsi/Open-iscsi/lib/iSCSIExec.py", line 18, in runExec
      raise Exception("Run cmd %s failed: \n errcode = %d, \n %s" % (cmd, errCode, errMsg))
  Exception: Run cmd tcm_node --block iblock_0/test_send /dev/send failed: 
   errcode = 1, 
   /bin/ls: cannot access /dev/send: No such file or directory
  Traceback (most recent call last):
    File "/usr/sbin/tcm_node", line 747, in <module>
      main()
    File "/usr/sbin/tcm_node", line 739, in main
      (options, args) = parser.parse_args()
    File "/usr/lib/python2.7/optparse.py", line 1399, in parse_args
      stop = self._process_args(largs, rargs, values)
    File "/usr/lib/python2.7/optparse.py", line 1439, in _process_args
      self._process_long_opt(rargs, values)
    File "/usr/lib/python2.7/optparse.py", line 1514, in _process_long_opt
      option.process(opt, value, values, self)
    File "/usr/lib/python2.7/optparse.py", line 788, in process
      self.action, self.dest, opt, value, values, parser)
    File "/usr/lib/python2.7/optparse.py", line 808, in take_action
      self.callback(self, opt, value, parser, *args, **kwargs)
    File "/usr/sbin/tcm_node", line 719, in dispatcher
      orig_callback(*value)
    File "/usr/sbin/tcm_node", line 305, in tcm_create_iblock
      tcm_createvirtdev(dev_path, udev_path)
    File "/usr/sbin/tcm_node", line 223, in tcm_createvirtdev
      tcm["module"].createvirtdev(dev_path, [plugin_params])
    File "/usr/share/pyshared/tcm_iblock.py", line 25, in createvirtdev
      major = out[4]
  IndexError: list index out of range
  
  
2013-06-04 09:35:15,579 DEBUG run ssh -i  ~/.ssh/key root@192.168.146.233 "python /root/program/iscsi/Open-iscsi/lib/sendtarget.py send send" 
2013-06-04 09:35:16,241 INFO Call interface sendTarget(send, iqn.1993-08.org.debian:01:fcc9228c36cc)...
2013-06-04 09:35:16,241 DEBUG run tcm_node --block iblock_0/test_send /dev/send 
2013-06-04 09:35:16,372 ERROR Traceback (most recent call last):
    File "/root/program/iscsi/Open-iscsi/lib/sendtarget.py", line 163, in sendTarget
      actionTcmCreate(rollback, ('test', lvName))
    File "/root/program/iscsi/Open-iscsi/lib/sendtarget.py", line 78, in actionTcmCreate
      runExec(osCmd)
    File "/root/program/iscsi/Open-iscsi/lib/iSCSIExec.py", line 18, in runExec
      raise Exception("Run cmd %s failed: \n errcode = %d, \n %s" % (cmd, errCode, errMsg))
  Exception: Run cmd tcm_node --block iblock_0/test_send /dev/send failed: 
   errcode = 1, 
   /bin/ls: cannot access /dev/send: No such file or directory
  Traceback (most recent call last):
    File "/usr/sbin/tcm_node", line 747, in <module>
      main()
    File "/usr/sbin/tcm_node", line 739, in main
      (options, args) = parser.parse_args()
    File "/usr/lib/python2.7/optparse.py", line 1399, in parse_args
      stop = self._process_args(largs, rargs, values)
    File "/usr/lib/python2.7/optparse.py", line 1439, in _process_args
      self._process_long_opt(rargs, values)
    File "/usr/lib/python2.7/optparse.py", line 1514, in _process_long_opt
      option.process(opt, value, values, self)
    File "/usr/lib/python2.7/optparse.py", line 788, in process
      self.action, self.dest, opt, value, values, parser)
    File "/usr/lib/python2.7/optparse.py", line 808, in take_action
      self.callback(self, opt, value, parser, *args, **kwargs)
    File "/usr/sbin/tcm_node", line 719, in dispatcher
      orig_callback(*value)
    File "/usr/sbin/tcm_node", line 305, in tcm_create_iblock
      tcm_createvirtdev(dev_path, udev_path)
    File "/usr/sbin/tcm_node", line 223, in tcm_createvirtdev
      tcm["module"].createvirtdev(dev_path, [plugin_params])
    File "/usr/share/pyshared/tcm_iblock.py", line 25, in createvirtdev
      major = out[4]
  IndexError: list index out of range
  
  
2013-06-04 09:35:16,373 INFO purgeIqn success
2013-06-04 09:35:16,373 DEBUG purgeTcm success
2013-06-04 09:35:16,374 DEBUG purgeIscsi success
2013-06-04 09:35:16,374 INFO Call interface sendTarget(send, iqn.1993-08.org.debian:01:fcc9228c36cc)...
2013-06-04 09:35:16,374 DEBUG run tcm_node --block iblock_0/test_send /dev/send 
2013-06-04 09:35:16,511 ERROR Traceback (most recent call last):
    File "/root/program/iscsi/Open-iscsi/lib/sendtarget.py", line 163, in sendTarget
      actionTcmCreate(rollback, ('test', lvName))
    File "/root/program/iscsi/Open-iscsi/lib/sendtarget.py", line 78, in actionTcmCreate
      runExec(osCmd)
    File "/root/program/iscsi/Open-iscsi/lib/iSCSIExec.py", line 18, in runExec
      raise Exception("Run cmd %s failed: \n errcode = %d, \n %s" % (cmd, errCode, errMsg))
  Exception: Run cmd tcm_node --block iblock_0/test_send /dev/send failed: 
   errcode = 1, 
   /bin/ls: cannot access /dev/send: No such file or directory
  Traceback (most recent call last):
    File "/usr/sbin/tcm_node", line 747, in <module>
      main()
    File "/usr/sbin/tcm_node", line 739, in main
      (options, args) = parser.parse_args()
    File "/usr/lib/python2.7/optparse.py", line 1399, in parse_args
      stop = self._process_args(largs, rargs, values)
    File "/usr/lib/python2.7/optparse.py", line 1439, in _process_args
      self._process_long_opt(rargs, values)
    File "/usr/lib/python2.7/optparse.py", line 1514, in _process_long_opt
      option.process(opt, value, values, self)
    File "/usr/lib/python2.7/optparse.py", line 788, in process
      self.action, self.dest, opt, value, values, parser)
    File "/usr/lib/python2.7/optparse.py", line 808, in take_action
      self.callback(self, opt, value, parser, *args, **kwargs)
    File "/usr/sbin/tcm_node", line 719, in dispatcher
      orig_callback(*value)
    File "/usr/sbin/tcm_node", line 305, in tcm_create_iblock
      tcm_createvirtdev(dev_path, udev_path)
    File "/usr/sbin/tcm_node", line 223, in tcm_createvirtdev
      tcm["module"].createvirtdev(dev_path, [plugin_params])
    File "/usr/share/pyshared/tcm_iblock.py", line 25, in createvirtdev
      major = out[4]
  IndexError: list index out of range
  
  
2013-06-04 09:35:31,687 INFO Call interface sendTarget(loop0, iqn.1993-08.org.debian:01:fcc9228c36cc)...
2013-06-04 09:35:31,690 DEBUG run tcm_node --block iblock_0/test_loop0 /dev/loop0 
2013-06-04 09:35:31,773 ERROR Traceback (most recent call last):
    File "sendtarget.py", line 163, in sendTarget
      actionTcmCreate(rollback, ('test', lvName))
    File "sendtarget.py", line 78, in actionTcmCreate
      runExec(osCmd)
    File "/root/program/iscsi/Open-iscsi/lib/iSCSIExec.py", line 18, in runExec
      raise Exception("Run cmd %s failed: \n errcode = %d, \n %s" % (cmd, errCode, errMsg))
  Exception: Run cmd tcm_node --block iblock_0/test_loop0 /dev/loop0 failed: 
   errcode = 1, 
   TCM/ConfigFS storage object already exists: /sys/kernel/config/target/core/iblock_0/test_loop0
  
  
2013-06-04 09:35:31,777 DEBUG run lio_node --deltpg test:123456:loop0 1 
2013-06-04 09:35:31,926 INFO purgeIqn success
2013-06-04 09:35:31,928 DEBUG run tcm_node --freedev iblock_0/test_loop0 
2013-06-04 09:35:32,010 DEBUG purgeTcm success
2013-06-04 09:35:32,012 DEBUG run lio_node --deliqn=test:123456:loop0 
2013-06-04 09:35:32,080 DEBUG purgeIscsi success
2013-06-04 09:35:32,081 INFO Call interface sendTarget(loop0, iqn.1993-08.org.debian:01:fcc9228c36cc)...
2013-06-04 09:35:32,083 DEBUG run tcm_node --block iblock_0/test_loop0 /dev/loop0 
2013-06-04 09:35:32,199 DEBUG run lio_node --addlun test:123456:loop0 1 0 iscsi00 iblock_0/test_loop0 
2013-06-04 09:35:32,308 DEBUG run lio_node --addnp test:123456:loop0 1 0.0.0.0:3260 
2013-06-04 09:35:32,373 DEBUG run lio_node --enableauth test:123456:loop0 1 
2013-06-04 09:35:32,438 DEBUG run lio_node --addlunacl test:123456:loop0 1 iqn.1993-08.org.debian:01:fcc9228c36cc 0 0 
2013-06-04 09:35:32,512 DEBUG run lio_node --setchapauth test:123456:loop0 1 iqn.1993-08.org.debian:01:fcc9228c36cc nbs netease 
2013-06-04 09:35:32,580 DEBUG run lio_node --settpgattr=test:123456:loop0 1 cache_dynamic_acls 0 
2013-06-04 09:35:32,641 DEBUG run lio_node --enabletpg test:123456:loop0 1 
2013-06-04 09:35:32,710 INFO sendTarget success
2013-06-04 09:35:32,711 CRITICAL Traceback (most recent call last):
    File "sendtarget.py", line 215, in startTarget
      handler.sendTarget(lvName, initiatorName)
    File "sendtarget.py", line 195, in sendTarget
      raise Exception
  Exception
  
2013-06-04 09:35:34,335 INFO Call interface sendTarget(loop0, iqn.1993-08.org.debian:01:fcc9228c36cc)...
2013-06-04 09:35:34,340 DEBUG run tcm_node --block iblock_0/test_loop0 /dev/loop0 
2013-06-04 09:35:34,426 ERROR Traceback (most recent call last):
    File "sendtarget.py", line 163, in sendTarget
      actionTcmCreate(rollback, ('test', lvName))
    File "sendtarget.py", line 78, in actionTcmCreate
      runExec(osCmd)
    File "/root/program/iscsi/Open-iscsi/lib/iSCSIExec.py", line 18, in runExec
      raise Exception("Run cmd %s failed: \n errcode = %d, \n %s" % (cmd, errCode, errMsg))
  Exception: Run cmd tcm_node --block iblock_0/test_loop0 /dev/loop0 failed: 
   errcode = 1, 
   TCM/ConfigFS storage object already exists: /sys/kernel/config/target/core/iblock_0/test_loop0
  
  
2013-06-04 09:35:34,430 DEBUG run lio_node --deltpg test:123456:loop0 1 
2013-06-04 09:35:35,110 INFO purgeIqn success
2013-06-04 09:35:35,112 DEBUG run tcm_node --freedev iblock_0/test_loop0 
2013-06-04 09:35:35,212 DEBUG purgeTcm success
2013-06-04 09:35:35,215 DEBUG run lio_node --deliqn=test:123456:loop0 
2013-06-04 09:35:35,304 DEBUG purgeIscsi success
2013-06-04 09:35:35,306 INFO Call interface sendTarget(loop0, iqn.1993-08.org.debian:01:fcc9228c36cc)...
2013-06-04 09:35:35,307 DEBUG run tcm_node --block iblock_0/test_loop0 /dev/loop0 
2013-06-04 09:35:35,416 DEBUG run lio_node --addlun test:123456:loop0 1 0 iscsi00 iblock_0/test_loop0 
2013-06-04 09:35:35,497 DEBUG run lio_node --addnp test:123456:loop0 1 0.0.0.0:3260 
2013-06-04 09:35:35,565 DEBUG run lio_node --enableauth test:123456:loop0 1 
2013-06-04 09:35:35,630 DEBUG run lio_node --addlunacl test:123456:loop0 1 iqn.1993-08.org.debian:01:fcc9228c36cc 0 0 
2013-06-04 09:35:35,703 DEBUG run lio_node --setchapauth test:123456:loop0 1 iqn.1993-08.org.debian:01:fcc9228c36cc nbs netease 
2013-06-04 09:35:35,771 DEBUG run lio_node --settpgattr=test:123456:loop0 1 cache_dynamic_acls 0 
2013-06-04 09:35:35,829 DEBUG run lio_node --enabletpg test:123456:loop0 1 
2013-06-04 09:35:35,894 INFO sendTarget success
2013-06-04 09:35:35,895 CRITICAL Traceback (most recent call last):
    File "sendtarget.py", line 215, in startTarget
      handler.sendTarget(lvName, initiatorName)
    File "sendtarget.py", line 195, in sendTarget
      raise Exception
  Exception
  
2013-06-04 09:36:10,546 INFO Call interface sendTarget(loop0, iqn.1993-08.org.debian:01:fcc9228c36cc)...
2013-06-04 09:36:10,546 DEBUG run tcm_node --block iblock_0/test_loop0 /dev/loop0 
2013-06-04 09:36:10,630 ERROR Traceback (most recent call last):
    File "sendtarget.py", line 163, in sendTarget
      actionTcmCreate(rollback, ('test', lvName))
    File "sendtarget.py", line 78, in actionTcmCreate
      runExec(osCmd)
    File "/root/program/iscsi/Open-iscsi/lib/iSCSIExec.py", line 18, in runExec
      raise Exception("Run cmd %s failed: \n errcode = %d, \n %s" % (cmd, errCode, errMsg))
  Exception: Run cmd tcm_node --block iblock_0/test_loop0 /dev/loop0 failed: 
   errcode = 1, 
   TCM/ConfigFS storage object already exists: /sys/kernel/config/target/core/iblock_0/test_loop0
  
  
2013-06-04 09:36:10,633 DEBUG run lio_node --deltpg test:123456:loop0 1 
2013-06-04 09:36:10,729 INFO purgeIqn success
2013-06-04 09:36:10,730 DEBUG run tcm_node --freedev iblock_0/test_loop0 
2013-06-04 09:36:10,828 DEBUG purgeTcm success
2013-06-04 09:36:10,830 DEBUG run lio_node --deliqn=test:123456:loop0 
2013-06-04 09:36:10,898 DEBUG purgeIscsi success
2013-06-04 09:36:10,900 INFO Call interface sendTarget(loop0, iqn.1993-08.org.debian:01:fcc9228c36cc)...
2013-06-04 09:36:10,900 DEBUG run tcm_node --block iblock_0/test_loop0 /dev/loop0 
2013-06-04 09:36:11,010 DEBUG run lio_node --addlun test:123456:loop0 1 0 iscsi00 iblock_0/test_loop0 
2013-06-04 09:36:11,089 DEBUG run lio_node --addnp test:123456:loop0 1 0.0.0.0:3260 
2013-06-04 09:36:11,157 DEBUG run lio_node --enableauth test:123456:loop0 1 
2013-06-04 09:36:11,234 DEBUG run lio_node --addlunacl test:123456:loop0 1 iqn.1993-08.org.debian:01:fcc9228c36cc 0 0 
2013-06-04 09:36:11,315 DEBUG run lio_node --setchapauth test:123456:loop0 1 iqn.1993-08.org.debian:01:fcc9228c36cc nbs netease 
2013-06-04 09:36:11,398 DEBUG run lio_node --settpgattr=test:123456:loop0 1 cache_dynamic_acls 0 
2013-06-04 09:36:11,455 DEBUG run lio_node --enabletpg test:123456:loop0 1 
2013-06-04 09:36:11,526 INFO sendTarget success
2013-06-04 09:36:11,528 CRITICAL Traceback (most recent call last):
    File "sendtarget.py", line 215, in startTarget
      handler.sendTarget(lvName, initiatorName)
    File "sendtarget.py", line 195, in sendTarget
      raise Exception
  Exception
  
2013-06-04 09:36:12,988 INFO Call interface sendTarget(loop0, iqn.1993-08.org.debian:01:fcc9228c36cc)...
2013-06-04 09:36:12,989 DEBUG run tcm_node --block iblock_0/test_loop0 /dev/loop0 
2013-06-04 09:36:13,073 ERROR Traceback (most recent call last):
    File "sendtarget.py", line 163, in sendTarget
      actionTcmCreate(rollback, ('test', lvName))
    File "sendtarget.py", line 78, in actionTcmCreate
      runExec(osCmd)
    File "/root/program/iscsi/Open-iscsi/lib/iSCSIExec.py", line 18, in runExec
      raise Exception("Run cmd %s failed: \n errcode = %d, \n %s" % (cmd, errCode, errMsg))
  Exception: Run cmd tcm_node --block iblock_0/test_loop0 /dev/loop0 failed: 
   errcode = 1, 
   TCM/ConfigFS storage object already exists: /sys/kernel/config/target/core/iblock_0/test_loop0
  
  
2013-06-04 09:36:13,077 DEBUG run lio_node --deltpg test:123456:loop0 1 
2013-06-04 09:36:13,173 INFO purgeIqn success
2013-06-04 09:36:13,175 DEBUG run tcm_node --freedev iblock_0/test_loop0 
2013-06-04 09:36:13,256 DEBUG purgeTcm success
2013-06-04 09:36:13,257 DEBUG run lio_node --deliqn=test:123456:loop0 
2013-06-04 09:36:13,336 DEBUG purgeIscsi success
2013-06-04 09:36:13,338 INFO Call interface sendTarget(loop0, iqn.1993-08.org.debian:01:fcc9228c36cc)...
2013-06-04 09:36:13,339 DEBUG run tcm_node --block iblock_0/test_loop0 /dev/loop0 
2013-06-04 09:36:13,455 DEBUG run lio_node --addlun test:123456:loop0 1 0 iscsi00 iblock_0/test_loop0 
2013-06-04 09:36:13,535 DEBUG run lio_node --addnp test:123456:loop0 1 0.0.0.0:3260 
2013-06-04 09:36:13,600 DEBUG run lio_node --enableauth test:123456:loop0 1 
2013-06-04 09:36:13,669 DEBUG run lio_node --addlunacl test:123456:loop0 1 iqn.1993-08.org.debian:01:fcc9228c36cc 0 0 
2013-06-04 09:36:13,742 DEBUG run lio_node --setchapauth test:123456:loop0 1 iqn.1993-08.org.debian:01:fcc9228c36cc nbs netease 
2013-06-04 09:36:13,811 DEBUG run lio_node --settpgattr=test:123456:loop0 1 cache_dynamic_acls 0 
2013-06-04 09:36:13,868 DEBUG run lio_node --enabletpg test:123456:loop0 1 
2013-06-04 09:36:13,935 INFO sendTarget success
2013-06-04 09:36:13,936 CRITICAL Traceback (most recent call last):
    File "sendtarget.py", line 215, in startTarget
      handler.sendTarget(lvName, initiatorName)
    File "sendtarget.py", line 195, in sendTarget
      raise Exception
  Exception
  
2013-06-04 09:38:51,653 INFO Call interface sendTarget(loop0, iqn.1993-08.org.debian:01:fcc9228c36cc)...
2013-06-04 09:38:51,653 DEBUG run tcm_node --block iblock_0/test_loop0 /dev/loop0 
2013-06-04 09:38:51,758 ERROR Traceback (most recent call last):
    File "sendtarget.py", line 163, in sendTarget
      actionTcmCreate(rollback, ('test', lvName))
    File "sendtarget.py", line 78, in actionTcmCreate
      runExec(osCmd)
    File "/root/program/iscsi/Open-iscsi/lib/iSCSIExec.py", line 18, in runExec
      raise Exception("Run cmd %s failed: \n errcode = %d, \n %s" % (cmd, errCode, errMsg))
  Exception: Run cmd tcm_node --block iblock_0/test_loop0 /dev/loop0 failed: 
   errcode = 1, 
   TCM/ConfigFS storage object already exists: /sys/kernel/config/target/core/iblock_0/test_loop0
  
  
2013-06-04 09:38:51,762 DEBUG run lio_node --deltpg test:123456:loop0 1 
2013-06-04 09:38:51,861 INFO purgeIqn success
2013-06-04 09:38:51,863 DEBUG run tcm_node --freedev iblock_0/test_loop0 
2013-06-04 09:38:51,946 DEBUG purgeTcm success
2013-06-04 09:38:51,948 DEBUG run lio_node --deliqn=test:123456:loop0 
2013-06-04 09:38:52,014 DEBUG purgeIscsi success
2013-06-04 09:38:52,017 INFO Call interface sendTarget(loop0, iqn.1993-08.org.debian:01:fcc9228c36cc)...
2013-06-04 09:38:52,017 DEBUG run tcm_node --block iblock_0/test_loop0 /dev/loop0 
2013-06-04 09:38:52,122 DEBUG run lio_node --addlun test:123456:loop0 1 0 iscsi00 iblock_0/test_loop0 
2013-06-04 09:38:52,200 DEBUG run lio_node --addnp test:123456:loop0 1 0.0.0.0:3260 
2013-06-04 09:38:52,268 DEBUG run lio_node --enableauth test:123456:loop0 1 
2013-06-04 09:38:52,331 DEBUG run lio_node --addlunacl test:123456:loop0 1 iqn.1993-08.org.debian:01:fcc9228c36cc 0 0 
2013-06-04 09:38:52,403 DEBUG run lio_node --setchapauth test:123456:loop0 1 iqn.1993-08.org.debian:01:fcc9228c36cc nbs netease 
2013-06-04 09:38:52,473 DEBUG run lio_node --settpgattr=test:123456:loop0 1 cache_dynamic_acls 0 
2013-06-04 09:38:52,532 DEBUG run lio_node --enabletpg test:123456:loop0 1 
2013-06-04 09:38:52,597 INFO sendTarget success
2013-06-04 09:38:52,600 CRITICAL Traceback (most recent call last):
    File "sendtarget.py", line 216, in startTarget
      handler.sendTarget(lvName, initiatorName)
    File "sendtarget.py", line 195, in sendTarget
      raise Exception
  Exception
  
2013-06-04 09:41:45,309 INFO Call interface sendTarget(loop0, iqn.1993-08.org.debian:01:fcc9228c36cc)...
2013-06-04 09:41:45,309 DEBUG run tcm_node --block iblock_0/test_loop0 /dev/loop0 
2013-06-04 09:41:45,394 ERROR Traceback (most recent call last):
    File "sendtarget.py", line 163, in sendTarget
      actionTcmCreate(rollback, ('test', lvName))
    File "sendtarget.py", line 78, in actionTcmCreate
      runExec(osCmd)
    File "/root/program/iscsi/Open-iscsi/lib/iSCSIExec.py", line 18, in runExec
      raise Exception("Run cmd %s failed: \n errcode = %d, \n %s" % (cmd, errCode, errMsg))
  Exception: Run cmd tcm_node --block iblock_0/test_loop0 /dev/loop0 failed: 
   errcode = 1, 
   TCM/ConfigFS storage object already exists: /sys/kernel/config/target/core/iblock_0/test_loop0
  
  
2013-06-04 09:41:45,398 DEBUG run lio_node --deltpg test:123456:loop0 1 
2013-06-04 09:41:45,499 INFO purgeIqn success
2013-06-04 09:41:45,501 DEBUG run tcm_node --freedev iblock_0/test_loop0 
2013-06-04 09:41:45,580 DEBUG purgeTcm success
2013-06-04 09:41:45,582 DEBUG run lio_node --deliqn=test:123456:loop0 
2013-06-04 09:41:45,650 DEBUG purgeIscsi success
2013-06-04 09:41:45,651 INFO Call interface sendTarget(loop0, iqn.1993-08.org.debian:01:fcc9228c36cc)...
2013-06-04 09:41:45,652 DEBUG run tcm_node --block iblock_0/test_loop0 /dev/loop0 
2013-06-04 09:41:45,769 DEBUG run lio_node --addlun test:123456:loop0 1 0 iscsi00 iblock_0/test_loop0 
2013-06-04 09:41:45,847 DEBUG run lio_node --addnp test:123456:loop0 1 0.0.0.0:3260 
2013-06-04 09:41:45,915 DEBUG run lio_node --enableauth test:123456:loop0 1 
2013-06-04 09:41:45,981 DEBUG run lio_node --addlunacl test:123456:loop0 1 iqn.1993-08.org.debian:01:fcc9228c36cc 0 0 
2013-06-04 09:41:46,073 DEBUG run lio_node --setchapauth test:123456:loop0 1 iqn.1993-08.org.debian:01:fcc9228c36cc nbs netease 
2013-06-04 09:41:46,141 DEBUG run lio_node --settpgattr=test:123456:loop0 1 cache_dynamic_acls 0 
2013-06-04 09:41:46,196 DEBUG run lio_node --enabletpg test:123456:loop0 1 
2013-06-04 09:41:46,264 INFO sendTarget success
2013-06-04 09:41:46,267 CRITICAL Traceback (most recent call last):
    File "sendtarget.py", line 216, in startTarget
      handler.sendTarget(lvName, initiatorName)
    File "sendtarget.py", line 195, in sendTarget
      raise Exception
  Exception
  
2013-06-04 09:41:52,567 DEBUG run lio_node --deltpg test:123456:loop0 1 
2013-06-04 09:41:52,666 INFO purgeIqn success
2013-06-04 09:41:52,668 DEBUG run tcm_node --freedev iblock_0/test_loop0 
2013-06-04 09:41:52,755 DEBUG purgeTcm success
2013-06-04 09:41:52,756 DEBUG run lio_node --deliqn=test:123456:loop0 
2013-06-04 09:41:52,821 DEBUG purgeIscsi success
2013-06-04 09:41:52,824 DEBUG purgeTarget success
2013-06-04 09:41:54,283 INFO Call interface sendTarget(loop0, iqn.1993-08.org.debian:01:fcc9228c36cc)...
2013-06-04 09:41:54,284 DEBUG run tcm_node --block iblock_0/test_loop0 /dev/loop0 
2013-06-04 09:41:54,399 DEBUG run lio_node --addlun test:123456:loop0 1 0 iscsi00 iblock_0/test_loop0 
2013-06-04 09:41:54,478 DEBUG run lio_node --addnp test:123456:loop0 1 0.0.0.0:3260 
2013-06-04 09:41:54,549 DEBUG run lio_node --enableauth test:123456:loop0 1 
2013-06-04 09:41:54,615 DEBUG run lio_node --addlunacl test:123456:loop0 1 iqn.1993-08.org.debian:01:fcc9228c36cc 0 0 
2013-06-04 09:41:54,685 DEBUG run lio_node --setchapauth test:123456:loop0 1 iqn.1993-08.org.debian:01:fcc9228c36cc nbs netease 
2013-06-04 09:41:54,757 DEBUG run lio_node --settpgattr=test:123456:loop0 1 cache_dynamic_acls 0 
2013-06-04 09:41:54,813 DEBUG run lio_node --enabletpg test:123456:loop0 1 
2013-06-04 09:41:54,879 INFO sendTarget success
2013-06-04 09:41:54,880 DEBUG sendTarget success
2013-06-04 09:41:56,771 DEBUG run lio_node --deltpg test:123456:loop0 1 
2013-06-04 09:41:56,872 INFO purgeIqn success
2013-06-04 09:41:56,874 DEBUG run tcm_node --freedev iblock_0/test_loop0 
2013-06-04 09:41:56,957 DEBUG purgeTcm success
2013-06-04 09:41:56,959 DEBUG run lio_node --deliqn=test:123456:loop0 
2013-06-04 09:41:57,030 DEBUG purgeIscsi success
2013-06-04 09:41:57,033 DEBUG purgeTarget success
