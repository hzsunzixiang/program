 
$testvar=hello
file {'/etc/foo.conf':
      ensure  => file,
      content => template('/etc/puppet/modules/foo/files/foo.cnf.erb'),
    }
