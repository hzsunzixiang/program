
node default {
file { "/tmp/temp1.txt" :
content => "hello,world." ; }
}

node default {
file { "/tmp/link.txt" :
content => "hello,world." ; }


ensure => link,
target => "/tmp/temp1.txt",
}
