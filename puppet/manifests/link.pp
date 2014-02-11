
node default {
file { "/tmp/temp1.txt" :
content => "hello,world." ; }



file { "/tmp/temp.link":
  ensure => link,
  target => "/tmp/temp1.txt",
}
}
