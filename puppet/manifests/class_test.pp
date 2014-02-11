
$operatingsystem1=redhat

class mysql ($user = 'mysql', $port = 3306) {
	notify { "Hello World":
		name => "This will not be shown or logged.",
		message => "Hello, World! 你好, $user,$port"
	}
}

class {'mysql':
	user => mysqlserver,
	port => 8080,
}

#class {'mysql':
#	user => mysqlserver1,
#	port => 8090,
#}
#include mysql
