

# the user nbs,rds....
$project_name='nbs'
$package_version='1.1.1' 
$environ='qa'

class { "pyapp":
    source => 'nbs py  module' ,

#  # the environ  qa,integration,online,drill......

    test_var           => "$project_name-variable",

    process_user       => 'nbs',

    process_group      => 'nbs',

    exec_file          => 'com.netease.ebs.vmnode.server.VMNode',
    
    package_prefix     => 'VolumeManager' ,
    
    package_suffix     => 'distribution.zip' , 
    
    service            => "nbs-ha-$environ", #nbs-vm-qa.....
    
    # VolumeManager-$package_version-distribution.zip 
    #package_name => "$package_prefix-$package_version-$package_suffix" ,
    package_name       => "VolumeManager-$package_version-distribution.zip" ,

    # 二进制码文件"puppet:///modules/pyaapp/nbs-qa/nbs1.0/VolumeManager/target/VolumeManager-$package_version-distribution.zip" ,
    package_source_file => "puppet:///modules/pyaapp/nbs-$environ/nbs1.0/VolumeManager/target/VolumeManager-$package_version-distribution.zip" ,

    #package_source_file => "puppet:///modules/pyaapp/nbs-qa/nbs1.0/VolumeManager/target/$package_name" ,
    # 解压之后的目录
    unzip_file         => "VolumeManager-$package_version" ,

    app_name_suffix    => 'cloud-nbs-vm' ,

    app_source_dir     => 'puppet:///modules/pyaapp/scripts/java-app' ,

    # template 模板地址
    app_source_file    => 'pyaapp/java/javaApp.erb',

    config_dir => '/home/nbs/pyaapp-cloud-nbs-vm/conf/' ,

    config_source_dir => "puppet:///modules/pyaapp/nbs-$environ/nbs1.0/VolumeManager/src/main/resources/conf/$environ/199.20" ,
}



class { "pyapp":
    source => 'nbs py  module' ,

#  # the environ  qa,integration,online,drill......

    test_var           => "$project_name-variable",

    process_user       => 'nbs',

    process_group      => 'nbs',

    exec_file          => 'com.netease.ebs.vmnode.server.VMNode',
    
    package_prefix     => 'VolumeManager' ,
    
    package_suffix     => 'distribution.zip' , 
    
    service            => "nbs-ha-$environ", #nbs-vm-qa.....
    
    # VolumeManager-$package_version-distribution.zip 
    #package_name => "$package_prefix-$package_version-$package_suffix" ,
    package_name       => "VolumeManager-$package_version-distribution.zip" ,

    # 二进制码文件"puppet:///modules/pyaapp/nbs-qa/nbs1.0/VolumeManager/target/VolumeManager-$package_version-distribution.zip" ,
    package_source_file => "puppet:///modules/pyaapp/nbs-$environ/nbs1.0/VolumeManager/target/VolumeManager-$package_version-distribution.zip" ,

    #package_source_file => "puppet:///modules/pyaapp/nbs-qa/nbs1.0/VolumeManager/target/$package_name" ,
    # 解压之后的目录
    unzip_file         => "VolumeManager-$package_version" ,

    app_name_suffix    => 'cloud-nbs-vm' ,

    app_source_dir     => 'puppet:///modules/pyaapp/scripts/java-app' ,

    # template 模板地址
    app_source_file    => 'pyaapp/java/javaApp.erb',

    config_dir => '/home/nbs/pyaapp-cloud-nbs-vm/conf/' ,

    config_source_dir => "puppet:///modules/pyaapp/nbs-$environ/nbs1.0/VolumeManager/src/main/resources/conf/$environ/199.20" ,
}
