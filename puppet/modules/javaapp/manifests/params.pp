# Class: javaapp::params
#
# This class defines default parameters used by the main module class javaapp
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to javaapp class for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It may be imported or inherited by other classes
#
class javaapp::params {

  ### Application related parameters


  # the environment  qa,integration,online,drill......
  $environment = '' 

  # the user nbs,rds....
  $process_user = '' 
  $process_group = '' 

  $service  = 'VolumeManager' 

  $package_prefix = 'VolumeManager' 

  $package_suffix = 'distribution.zip' 

  $package_version = '1.1.1' 

  # VolumeManager-1.1.1-distribution.zip 
  $package_name = "$package_prefix-$package_version-$package_suffix"


  $app_name_suffix = 'cloud-nbs-vm'
  $app_source_dir = 'puppet:///modules/javaapp/scripts/java-app'
  # template 模板地址
  $app_source_file = 'javaapp/java/javaApp.erb'
  $service_status =  true

  $process = '' 

  $process_args = '' 


  $config_dir = '' 

  $config_file =  '' 

  $config_file_mode =  '' 

  $config_file_owner =  '' 

  $config_file_group =  '' 

  $config_file_init =  '' 

  $pid_file =  '' 

  $data_dir = '' 

  $log_dir =  '' 

  $log_file =  '' 


  # General Settings
  $my_class = '' 
  $source = 'test......' 
  $source_dir = '' 
  $service_autorestart = true 
  $absent = false 
  $disable = false 
  $disableboot = false 

}
