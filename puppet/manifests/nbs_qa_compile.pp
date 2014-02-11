class { "javaapp":
    source => 'nbs module' ,

# environment => 'qa' ,
    
#    # the user nbs,rds....
#    process_user => '' 
#    process_group => '' 
#    
#    service  => 'VolumeManager' 
#    
    package_prefix => 'VolumeManager' ,
    
    package_suffix => 'distribution.zip' , 
    
    package_version => '1.1.1' ,
    
    # VolumeManager-1.1.1-distribution.zip 
    #package_name => "$package_prefix-$package_version-$package_suffix" ,
    package_name => "VolumeManager-1.1.1-distribution.zip" ,
    
    
#    service_status =>  true
#    
#    process => '' 
#    
#    process_args => '' 
#    
#    
#    config_dir => '' 
#    
#    config_file =>  '' 
#    
#    config_file_mode =>  '' 
#    
#    config_file_owner =>  '' 
#    
#    config_file_group =>  '' 
#    
#    config_file_init =>  '' 
#    
#    pid_file =>  '' 
#    
#    data_dir => '' 
#    
#    log_dir =>  '' 
#    
#    log_file =>  '' 
}

class { "javaapp::maven_compile":
    source => 'nbs module' ,

# environment => 'qa' ,
    
#    # the user nbs,rds....
#    process_user => '' 
#    process_group => '' 
#    
#    service  => 'VolumeManager' 
#    
    
    javaapp_source            => '/etc/puppet/modules/javaapp/files/nbs-qa/nbs1.0/VolumeManager',
    maven_compile_cmd         => '/usr/bin/mvn package -Dmaven.test.skip=true',
    package_prefix            => 'VolumeManager' ,
    java_home                 => '/usr/lib/jvm/j2sdk1.6-oracle' ,
    maven_path                => ["/usr/local/sbin","/usr/local/bin","/usr/sbin","/usr/bin","/sbin","/bin"] ,
    maven_package_require           => ["unzip", "oracle-j2sdk1.6", "daemon","maven"],
    
    package_suffix            => 'distribution.zip' , 
    
    package_version           => '1.1.1' ,
    
    # VolumeManager-1.1.1-distribution.zip 
    #package_name => "$package_prefix-$package_version-$package_suffix" ,
    package_name              => "VolumeManager-1.1.1-distribution.zip" ,
    

}
