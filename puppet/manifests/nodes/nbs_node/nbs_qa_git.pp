


node '10-160-162-45.novalocal' {
   pyapp::git_operation {'qa':
       source              => 'qa',
       git_reset_cmd       => 'git reset --hard&&git pull',
       git_checkout_cmd    => 'git checkout develop',
       git_path            => ["/usr/local/sbin","/usr/local/bin","/usr/sbin","/usr/bin","/sbin","/bin"] ,
       git_cwd             => '/etc/puppet/modules/pyapp/files/nbs-qa/nbs1.0',
       purge_conf_file     => ["/etc/puppet/modules/pyapp/files/nbs-qa/nbs1.0/HostAgent/conf/hostagent-default.ini","/etc/puppet/modules/pyapp/files/nbs-qa/nbs1.0/VolumeServer/conf/vsnode-default.ini","/etc/puppet/modules/pyapp/files/nbs-qa/nbs1.0/ProxyAgent/conf/Configure.py"],
#       purge_conf_file     => ["/etc/puppet/modules/pyapp/files/nbs-qa/nbs1.0/HostAgent/conf/hostagent-default.ini",
#                          ',', "/etc/puppet/modules/pyapp/files/nbs-qa/nbs1.0/VolumeServer/conf/vsnode-default.ini",
#                          ',',"/etc/puppet/modules/pyapp/files/nbs-qa/nbs1.0/ProxyAgent/conf/Configure.py"],
#       purge_conf_file     => ["/etc/puppet/modules/pyapp/files/nbs-qa/nbs1.0/HostAgent/conf/hostagent-default.ini",
#       "/etc/puppet/modules/pyapp/files/nbs-qa/nbs1.0/VolumeServer/conf/vsnode-default.ini",
#       "/etc/puppet/modules/pyapp/files/nbs-qa/nbs1.0/ProxyAgent/conf/Configure.py"]


    }
}
