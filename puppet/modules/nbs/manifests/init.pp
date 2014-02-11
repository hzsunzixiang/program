class nbs {




# 确保git存在
# 确保nbs用户存在
# 确保本地先编译成功
# 然后同步到agent



# 先编译本地包

      package { 'ntp':
        ensure => installed,
      }
      file { 'ntp.conf':
        path    => '/etc/ntp.conf',
        ensure  => file,
        require => Package['ntp'],
        source  => "puppet:///modules/ntp/${conf_file}",
      }
      service { 'ntp':
        name      => $service_name,
        ensure    => running,
        enable    => true,
        subscribe => File['ntp.conf'],
      }
    }


node ''
