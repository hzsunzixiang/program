

# 根据各个节点书写对应的模块

# 部署qa 环境 VM
#node default {
#    import  "nodes/nbs_node/nbs_qa_vm.pp"
#}

# 编译qa 环境java工程
#node "10-160-162-45.novalocal" {
#    import  "nodes/nbs_node/nbs_qa_compile_vm.pp"
#}

# 部署qa 环境 HostAgent
#node default {
#    import  "nodes/nbs_node/nbs_qa_ha.pp"
#}
#


import "nodes/nbs_node/nbs_qa_vs.pp"
#node default {
#   pyapp::deploy {'qa':
#      source => 'qa',
#    }
#   pyapp::deploy {'integrate':
#      source => 'int',
#    }
#}



# 部署qa 环境VolumeServer



#node "10-160-162-45.novalocal" {
#$operatingsystem1=redhat
#$var_x="here,,,,,,,,,,,,,,,,,,,,,,"
#
#notify { "Hello World":
#  name => "This will not be shown or logged.",
#  message => "Hello, World! 你好, $servername ,$clientcert , $var_x, $::operatingsystem,$operatingsystem,$operatingsystem1,$::operatingsystem1"
#}
#
#}
