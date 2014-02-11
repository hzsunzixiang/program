class users::test {
 user {
     "nbs":
     ensure   => present,
     shell =>"/bin/bash",
     home  => "/home/nbs",
     managehome => true,
     comment =>"www.mysqlops.com test by sky add  test",
     password => 'nbs',
       }
}
node default { 
include users::test
}
