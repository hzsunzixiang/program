class test::test {
#file { "/tmp/sky":
#       owner  => root,
#       group  => root,
#       ensure => present,
#      content => "www.mysqlops.com test by sky",
#      mode    => 644,
#  }
#
	notify { "Hello World":
		name => "This will not be shown or logged.",
		message => "Hello, World! 你好,世界"
	}
}
