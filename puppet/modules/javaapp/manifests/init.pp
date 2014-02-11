# = Class: javaapp
#
# This is the main javaapp class
#
#
# == Parameters
#
# Standard class parameters
# Define the general class behaviour and customizations
#
# [*my_class*]
#   Name of a custom class to autoload to manage module's customizations
#   If defined, javaapp class will automatically "include $my_class"
#   Can be defined also by the (top scope) variable $javaapp_myclass
#
# [*source*]
#   Sets the content of source parameter for main configuration file
#   If defined, javaapp main config file will have the param: source => $source
#   Can be defined also by the (top scope) variable $javaapp_source
#
# [*source_dir*]
#   If defined, the whole javaapp configuration directory content is retrieved
#   recursively from the specified source
#   (source => $source_dir , recurse => true)
#   Can be defined also by the (top scope) variable $javaapp_source_dir
#
#
# [*package*]
#   The name of javaapp package
#
# [*service*]
#   The name of javaapp service
#
# [*service_status*]
#   If the javaapp service init script supports status argument
#
# [*process*]
#   The name of javaapp process
#
# [*config_dir*]
#   Main configuration directory. Used by puppi
#
# [*config_file*]
#   Main configuration file path
#
# [*config_file_mode*]
#   Main configuration file path mode
#
# [*config_file_owner*]
#   Main configuration file path owner
#
# [*config_file_group*]
#   Main configuration file path group
#
# [*config_file_init*]
#   Path of configuration file sourced by init script
#
# [*pid_file*]
#   Path of pid file. Used by monitor
#
# [*data_dir*]
#   Path of application data directory. Used by puppi
#
# [*log_dir*]
#   Base logs directory. Used by puppi
#
# [*log_file*]
#   Log file(s). Used by puppi
#
# == Examples
#
# You can use this class in 2 ways:
# - Set variables (at top scope level on in a ENC) and "include javaapp"
# - Call javaapp as a parametrized class
#
# See README for details.
#
class javaapp (
  $my_class            = params_lookup( 'my_class' ),
  $source              = params_lookup( 'source' ),
  $test_var            = params_lookup( 'test_var' ),
  $package_prefix      = params_lookup( 'package_prefix' ),
  $package_suffix      = params_lookup( 'package_suffix' ),
  $package_version     = params_lookup( 'package_version' ),
  $package_name        = params_lookup( 'package_name' ),
  $unzip_file          = params_lookup( 'unzip_file' ),
  $package_source_file = params_lookup( 'package_source_file' ),
  $app_name_suffix     = params_lookup( 'app_name_suffix' ),
  $exec_file           = params_lookup( 'exec_file' ),
  $project_name        = params_lookup( 'project_name' ),
  $service_status      = params_lookup( 'service_status' ),
  $process             = params_lookup( 'process' ),
  $process_args        = params_lookup( 'process_args' ),
  $config_dir          = params_lookup( 'config_dir' ),
  $config_source_dir   = params_lookup( 'config_source_dir' ),
  $config_file         = params_lookup( 'config_file' ),
  $config_file_mode    = params_lookup( 'config_file_mode' ),
  $config_file_init    = params_lookup( 'config_file_init' ),
  $source_dir          = params_lookup( 'source_dir' ),
  $source_dir_purge    = params_lookup( 'source_dir_purge' ),
  $template            = params_lookup( 'template' ),
  $service_autorestart = params_lookup( 'service_autorestart' , 'global' ),
  $options             = params_lookup( 'options' ),
  $absent              = params_lookup( 'absent' ),
  $disable             = params_lookup( 'disable' ),
  $disableboot         = params_lookup( 'disableboot' ),
  $service             = params_lookup( 'service' ),
  $service_status      = params_lookup( 'service_status' ),
  $process             = params_lookup( 'process' ),
  $process_args        = params_lookup( 'process_args' ),
  $process_user        = params_lookup( 'process_user' ),
  $process_group       = params_lookup( 'process_group' ),

  $app_source_dir      = params_lookup( 'app_source_dir' ),
  $app_source_file     = params_lookup( 'app_source_file' ),
  $config_dir          = params_lookup( 'config_dir' ),
  $config_file         = params_lookup( 'config_file' ),
  $config_file_mode    = params_lookup( 'config_file_mode' ),
  $config_file_owner   = params_lookup( 'config_file_owner' ),
  $config_file_group   = params_lookup( 'config_file_group' ),
  $config_file_init    = params_lookup( 'config_file_init' ),
  $pid_file            = params_lookup( 'pid_file' ),
  $data_dir            = params_lookup( 'data_dir' ),
  $log_dir             = params_lookup( 'log_dir' ),
  $log_file            = params_lookup( 'log_file' ),
  ) inherits javaapp::params {

    # 编译好之后，进行部署

    # 部署文件 形如 java-cloud-nbs-vm
    file { "/home/$process_user/java-$app_name_suffix":
      ensure                  => directory,
      group                   => $process_group,
      mode                    => 0755 ,
      owner                   => $process_user,
      recurse                 => true,
      source                  => $app_source_dir;

      "/home/$process_user/java-$app_name_suffix/javaApp":
      ensure                  => file,
      group                   => $process_group,
      mode                    => 0755 ,
      owner                   => $process_user,
      recurse                 => true,
      content                 => template($app_source_file),
      require                 => File["/home/$process_user/java-$app_name_suffix"];

      "/etc/init.d/$service":
      ensure                  => file,
      group                   => $process_group,
      mode                    => 0755 ,
      owner                   => $process_user,
      content                 => template($app_source_file);
    }

    # 部署文件 形如 javaapp-cloud-nbs-vm
    file { "/home/$process_user/javaapp-$app_name_suffix":
      ensure                  => directory,
      group                   => $process_group ,
      mode                    => 0755 ,
      owner                   => $process_user,
    }

    file { "/home/$process_user/javaapp-$app_name_suffix/$package_name":
      ensure                  => file,
      group                   => $process_group,
      mode                    => 0644 ,
      owner                   => $process_user,
      recurse                 => true,
      source                  => "$package_source_file",
      checksum                => md5,
      require                 => File["/home/$process_user/javaapp-$app_name_suffix"],
      notify                  => Exec["unzip-and-clean"],
    }


# 解压 ,各个工程是否不太一样？
    exec { "unzip-and-clean":
          #command => "unzip -o $package_name&&cp -rf  $unzip_file/* .&&rm -rf $unzip_file *.zip",
          command => "unzip -o $package_name&&cp -rf  $unzip_file/* .",
          cwd     => "/home/$process_user/javaapp-$app_name_suffix",
          user    => $process_user,
          path    => ["/usr/local/sbin","/usr/local/bin","/usr/sbin","/usr/bin","/sbin","/bin"],
          require => File["/home/$process_user/javaapp-$app_name_suffix/$package_name"],
          refreshonly =>true
    }

## 覆盖配置文件
    file { "$config_dir":
      checksum                => mtime,  #只有在内容改变时才进行拷贝，
      #checksum                => md5,  #只有在内容改变时才进行拷贝，
      ensure                  => directory,
      group                   => $process_group,
      mode                    => 0644 ,
      owner                   => $process_user,
      recurse                 => true,
      source                  => "$config_source_dir",
      require                 => [ File["/home/$process_user/javaapp-$app_name_suffix"], Exec["unzip-and-clean"] ],
      notify                  => Service[$service],  # 文件内容改变之后，通知服务重启
    }
# 保证java包存在
    package {
       [ "unzip", "oracle-j2sdk1.6", "daemon"]:
       ensure => installed;
     }
#  服务启动
    service { "$service":
      ensure     => running ,
      enable     => true , # Whether a service should be enabled to start at...
      require    => [ File["/etc/init.d/$service"], Exec["unzip-and-clean"] ],
    }



  if $operatingsystem =="debian" {
             notify { "Hello World":
              name => "This will not be shown or logged.",
              #message => "Hello, World! 你好, $source,$package_prefix,$package_suffix,$package_name"
              message => "Hello, World! 你好, $source $process_user $test_var,,,,,,,,,$project_name-xxxxx"
             }    
  }

}
