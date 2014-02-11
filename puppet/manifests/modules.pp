# /etc/puppet/manifests/modules.pp

#import "sudo"

#vim modules.pp #加载cron模块
import "cron" 
#import cron 

include cron
