# /etc/puppet/manifests/modules.pp

#import "sudo"

#vim modules.pp #加载cron模块
#import "test" 
#import "sudo" 
#import cron 

#include cron
#import "test:notify" 
#import  "notify1.pp"
#import  "/etc/puppet/modules/test/notify.pp"
#import  "/etc/puppet/modules/notify.pp"
#import  "test/notify.pp"



node default {
    include test::test
}


