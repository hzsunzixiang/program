 file {'/etc/foo.conf':
      ensure  => file,
      content => template('foo/foo.conf.erb'),
    }
