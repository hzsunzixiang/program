# Definition: pyapp::deploy
#
# This class installs Apache Virtual Hosts
#
# Parameters:
# - $aliases is a list of Alias hashes for mod_alias as per http://httpd.pyapp.org/docs/current/mod/mod_alias.html
#   each statement is a hash in the form of { alias => '/alias', path => '/real/path/to/directory' }
# - $directories is a lost of hashes for creating <Directory> statements as per http://httpd.pyapp.org/docs/2.2/mod/core.html#directory
#   each statement is a hash in the form of { path => '/path/to/directory', <directive> => <value>}
#   see README.md for list of supported directives.
#
# Requires:
# - The pyapp class
#
# Sample Usage:
#
#  # Simple deploy definition:
#  pyapp::deploy { 'site.name.fqdn':
#    port => '80',
#    docroot => '/path/to/docroot',
#  }
#
#  # SSL deploy with non-SSL rewrite:
#  pyapp::deploy { 'site.name.fqdn':
#    port    => '443',
#    ssl     => true,
#    docroot => '/path/to/docroot',
#  }
#  pyapp::deploy { 'site.name.fqdn':
#    port          => '80',
#    rewrite_cond => '%{HTTPS} off',
#    rewrite_rule => '(.*) https://%{HTTPS_HOST}%{REQUEST_URI}',
#  }
#  pyapp::deploy { 'site.name.fqdn':
#    port            => '80',
#    docroot         => '/path/to/other_docroot',
#    custom_fragment => template("${module_name}/my_fragment.erb"),
#  }
#
define pyapp::deploy(
     $source    = "undef",
     $con       =  undef,
     $package_version     =undef,
     $package_name        =undef,  # pyapp-cloud-nbs-ha
     $package_link_name   =undef,
     $package_source_file =undef, 
     $service_name        =undef,  # HostAgent,VolumeServer,ProxyAgent
     $project             =undef,  # HostAgent,VolumeServer,ProxyAgent
     $project_name        =undef,  # nbs,rds,ddb 
     $start_file          =undef,  # HostAgent.py
     $process_file        =undef,  # hostagent.pid
     $service             =undef, 
     $service_source_file =undef,
     $config_source_file  =undef,





     $exec_file           =undef,
     $project_name        =undef,
     $service_status      =undef,
     $process             =undef,
     $process_args        =undef,
     $config_dir          =undef,
     $config_source_dir   =undef,
     $config_file         =undef,
     $config_file_mode    =undef,
     $config_file_init    =undef,
     $source_dir          =undef,
     $source_dir_purge    =undef,
     $template            =undef,
     $service_autorestart =undef, 
     $options             =undef, 
     $absent              =undef, 
     $disable             =undef, 
     $disableboot         =undef, 
     $service_status      =undef, 
     $process             =undef, 
     $process_args        =undef, 
     $process_user        =undef, 
     $process_group       =undef, 
     ) {



    #开始部署，首先拷贝文件
    # package 存在

    # 部署文件 形如 java-cloud-nbs-vm
    file { "/home/$process_user/$package_name":
      ensure                  => directory,
      checksum                => md5,
      group                   => $process_group,
      #mode                    => 0755 ,
      owner                   => $process_user;

     # 部署工程文件
     "/home/$process_user/$package_name/$project":
      ensure                  => directory,
      checksum                => md5,
      ignore                  => ["*.pyc","*.log","*.pid"],
      #ignore                  => "README.TXT",
      group                   => $process_group,
      #mode                    => 0755 ,
      owner                   => $process_user,
      recurse                 => true,
      source                  => $package_source_file,
      require                 => File["/home/$process_user/$package_name"];

     # 创建一个链接文件
      "/home/$process_user/$package_link_name":
      ensure                  => link,
      checksum                => md5,
      group                   => $process_group,
      #mode                    => 0755 ,
      owner                   => $process_user,
      target                  => "/home/$process_user/$package_name/$project",
      require                 => File["/home/$process_user/$package_name/$project"];

      # 服务文件
      "/etc/init.d/$service":
      ensure                  => file,
      checksum                => md5,
      group                   => $process_group,
      mode                    => 0755 ,
      owner                   => $process_user,
      content                 => template($service_source_file);
    }
    # 拷贝配置文件
    file { "/home/$process_user/$package_link_name/conf/$config_file":
      ensure                  => file,
      checksum                => md5,
      group                   => $process_group,
      #mode                    => 0755 ,
      owner                   => $process_user,
      source                  => $config_source_file,
      notify                  => Service[$service],  # 文件内容改变之后，通知服务重启notify 
    }
    # 保证服务启动,且配置文件改变时，服务需要重启
    service { "$service":
      ensure     => running ,
      enable     => true , # Whether a service should be enabled to start at...
      require    => File["/etc/init.d/$service"],
    }



 # 定义多个notify竟然不可以
 if $source == 'qa' {
      notify { "${source}":
          name => "This will not be shown or logged.",
          message => "Hello, World! 你好, $source /home/$process_user/$package_name/$project/conf/$config_file"
      }
 }

 file { "/tmp/${source}.conf":
          # This template can access all of the parameters and variables from above.
        ensure  => file,
        owner   => 'nbs',
        group   => 'nbs',
        mode    => '644',
        content =>  $con,
      }
}

