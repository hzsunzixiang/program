# = Class: pyapp
#
# This is the main pyapp class
#
#
# == Parameters
#
# Standard class parameters
# Define the general class behaviour and customizations
#
# [*my_class*]
#   Name of a custom class to autoload to manage module's customizations
#   If defined, pyapp class will automatically "include $my_class"
#   Can be defined also by the (top scope) variable $pyapp_myclass
#
# [*source*]
#   Sets the content of source parameter for main configuration file
#   If defined, pyapp main config file will have the param: source => $source
#   Can be defined also by the (top scope) variable $pyapp_source
#
# [*source_dir*]
#   If defined, the whole pyapp configuration directory content is retrieved
#   recursively from the specified source
#   (source => $source_dir , recurse => true)
#   Can be defined also by the (top scope) variable $pyapp_source_dir
#
# [*disable*]
#   Set to 'true' to disable service(s) managed by module
#   Can be defined also by the (top scope) variable $pyapp_disable
#
# [*disableboot*]
#   Set to 'true' to disable service(s) at boot, without checks if it's running
#   Use this when the service is managed by a tool like a cluster software
#   Can be defined also by the (top scope) variable $pyapp_disableboot
#
# [*package*]
#   The name of pyapp package
#
# [*service*]
#   The name of pyapp service
#
# [*service_status*]
#   If the pyapp service init script supports status argument
#
# [*process*]
#   The name of pyapp process
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
#
# == Examples
#
# You can use this class in 2 ways:
# - Set variables (at top scope level on in a ENC) and "include pyapp"
# - Call pyapp as a parametrized class
#
# See README for details.
#

# 这种操作不能让其自动化，不然会自动更新
# 每次更新时手工操作
define pyapp::git_operation (
  $my_class                =undef , 
  $source                  =undef , 
  $pyapp_source            =undef , 
  $git_path                =undef ,
  $git_cwd                 =undef , 
  $git_reset_cmd           =undef , 
  $git_checkout_cmd        =undef , 
  $purge_conf_file         =undef ,  # 需要purge掉的文件路径:
  ) {

# git reset , pull ,checkout 
    exec { "$git_reset_cmd":
          cwd          =>  $git_cwd ,
          path         =>  $git_path ;
          "$git_checkout_cmd":
          cwd          =>  $git_cwd ,
          path         =>  $git_path ,
          require      => Exec[$git_reset_cmd] ,
    }

# 把配置文件purge掉,这个文件是要被具体的配置覆盖掉的
# 这样做的目的是为了确保：在配置文件改动时可以重启服务.
    file { $purge_conf_file: # 这个是数组，这里不能加双引号，不然错误
      ensure                  => absent,
      require      => Exec[$git_checkout_cmd] ,
    }

    


  notify { "Hello World,,":
   name => "This will not be shown or logged.another",
   message => "Hello, World! 你好, ........app1..... $purge_conf_file,$git_path",
 }
  

}
