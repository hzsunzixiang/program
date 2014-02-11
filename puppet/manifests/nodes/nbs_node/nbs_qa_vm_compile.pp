
# 为了编译java代码
class { "javaapp::maven_compile":

    source => 'nbs module' ,

    git_reset_cmd             => 'git reset --hard&&git pull',
    git_checkout_cmd          => 'git checkout develop',
    git_cwd                   => '/etc/puppet/modules/javaapp/files/nbs-qa/nbs1.0/',
    git_path                  => ["/usr/local/sbin","/usr/local/bin","/usr/sbin","/usr/bin","/sbin","/bin"] ,

    javaapp_source            => '/etc/puppet/modules/javaapp/files/nbs-qa/nbs1.0/VolumeManager',
    maven_compile_cmd         => '/usr/bin/mvn package -Dmaven.test.skip=true',
    package_prefix            => 'VolumeManager' ,
    java_home                 => '/usr/lib/jvm/j2sdk1.6-oracle' ,
    maven_path                => ["/usr/local/sbin","/usr/local/bin","/usr/sbin","/usr/bin","/sbin","/bin"] ,
    maven_package_require     => ["git", "unzip", "oracle-j2sdk1.6", "daemon","maven"],
    package_suffix            => 'distribution.zip' , 
    #package_version          => '1.1.1' ,
    # VolumeManager-1.1.1-distribution.zip 
    #package_name => "$package_prefix-$package_version-$package_suffix" ,
    package_name              => "VolumeManager-1.1.1-distribution.zip" ,

}
