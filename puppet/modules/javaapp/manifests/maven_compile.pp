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
# [*disable*]
#   Set to 'true' to disable service(s) managed by module
#   Can be defined also by the (top scope) variable $javaapp_disable
#
# [*disableboot*]
#   Set to 'true' to disable service(s) at boot, without checks if it's running
#   Use this when the service is managed by a tool like a cluster software
#   Can be defined also by the (top scope) variable $javaapp_disableboot
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
#
# == Examples
#
# You can use this class in 2 ways:
# - Set variables (at top scope level on in a ENC) and "include javaapp"
# - Call javaapp as a parametrized class
#
# See README for details.
#
class javaapp::maven_compile (
  $my_class                = params_lookup( 'my_class' ),
  $source                  = params_lookup( 'source' ),
  $javaapp_source          = params_lookup( 'javaapp_source' ),
  $maven_compile_cmd       = params_lookup( 'maven_compile_cmd' ),
  $java_home               = params_lookup( 'java_home' ),
  $maven_package_require   = params_lookup( 'maven_package_require' ),
  $git_path                = params_lookup( 'git_path' ),
  $git_cwd                 = params_lookup( 'git_cwd' ),
  $git_reset_cmd           = params_lookup( 'git_reset_cmd' ),
  $git_checkout_cmd        = params_lookup( 'git_checkout_cmd' ),
  $package_prefix          = params_lookup( 'package_prefix' ),
  $package_suffix          = params_lookup( 'package_suffix' ),
  $package_version     = params_lookup( 'package_version' ),
  $package_name        = params_lookup( 'package_name' ),
  $maven_path              = params_lookup( 'maven_path' ),
  ) inherits javaapp::params {

# 主控节点首先编译工程

# 保证jdk存在
# 保证java包存在
    package {
       $maven_package_require: 
       ensure => installed;
     }

# git reset , pull ,checkout 

    exec { "$git_reset_cmd":
          cwd          => "$git_cwd" ,
          path         =>  $git_path ,
          require      => Package[$maven_package_require] ;

          "$git_checkout_cmd":
          cwd          => "$git_cwd" ,
          path         =>  $git_path ,
          require      => Exec[$git_reset_cmd] ,
    }

#  编译maven工程
    exec { "$maven_compile_cmd":
          cwd          => "$javaapp_source" ,
          path         =>  $maven_path ,
          environment  => "JAVA_HOME=$java_home" ,
          require      => Exec["$git_checkout_cmd"]
    }

  notify { "Hello World,,":
   name => "This will not be shown or logged.another",
   message => "Hello, World! 你好, ........app1....."
 }
  

}
