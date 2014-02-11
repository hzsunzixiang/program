# /etc/puppet/manifests/modules.pp

#import "sudo"

#vim modules.pp #加载cron模块
#import "cron" 
#import cron 

#include cron
#import "test:notify" 
#import  "notify1.pp"
#import  "/etc/puppet/modules/test/notify.pp"
#import  "/etc/puppet/modules/notify.pp"
#import  "notify.pp"

node default {
  package {
          "build-essential":
          ensure => installed;
        }
}

