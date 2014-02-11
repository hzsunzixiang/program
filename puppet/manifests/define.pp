

#define vhost ($var_x = '*') {
#    
#    $var_x             => "here,,,,,,,,,,,,,,,,,,,,,,"
#    notify { "Hello World":
#      name => "This will not be shown or logged.",
#      message => "Hello, World! 你好,  $var_x, "
#    }
#}


define vhost ($vhost_name = '*') {
  $vhost_dir = "hello"
  notify { "Hello World":
    name => "This will not be shown or logged.",
    message => "Hello, World! 你好,  $vhost_name, "
  }
}
vhost {'homepages':
    vhost_name => '/var/www-testhost', # Becomes the value of $docroot
  }


