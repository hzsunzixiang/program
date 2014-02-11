
$operatingsystem1=redhat
$var_x="here,,,,,,,,,,,,,,,,,,,,,,"

notify { "Hello World":
  name => "This will not be shown or logged.",
  message => "Hello, World! 你好, $servername ,$clientcert , $var_x, $::operatingsystem,$operatingsystem,$operatingsystem1,$::operatingsystem1"
}
