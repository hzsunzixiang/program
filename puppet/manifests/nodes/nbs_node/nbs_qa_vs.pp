


# 里面定义一些共有的变量，方便管理
node 'hostagent' {
      $con                 = 'this is a string,hello,world\n'
      $process_user        = 'nbs'
      $process_group       = 'nbs'
      $service_name        = 'HostAgent'
      $project             = 'HostAgent'
      $project_name        = 'nbs'
      $start_file          = 'HostAgent.py'
      $process_file        = 'hostagent.pid'
      $service_source_file = "pyapp/python/start-from-service.erb"
      $config_file         = "hostagent-default.ini"
   }

node '10-160-161-22.novalocal' inherits 'hostagent' {
   pyapp::deploy {'qa':
       source              => 'qa',
       con                 => $con,
       process_user        => $process_user,
       process_group       => $process_group,
       package_name        => 'git-nbs-ha-qa',
       package_link_name   => 'pyapp-cloud-nbs-ha-qa',
       service_name        => $service_name,
       project             => $project,
       project_name        => $project_name,
       start_file          => $start_file, 
       process_file        => $process_file,
       package_source_file => 'puppet:///modules/pyapp/nbs-qa/nbs1.0/HostAgent',
       service             => 'nbs-ha-qa',
       service_source_file => $service_source_file,
       config_file         => $config_file,
       config_source_file  => "puppet:///modules/pyapp/nbs-qa/nbs1.0/HostAgent/conf/conf/qa/199.15/hostagent-default.ini"

    }
#   pyapp::deploy {'integration':
#       source              => 'int',
#       con                 => $con,
#       process_user        => $process_user,
#       process_group       => $process_group,
#       package_name        => 'git-nbs-ha',
#       package_link_name   => 'pyapp-cloud-nbs-ha',
#       service_name        => $service_name,
#       project             => $project,
#       project_name        => $project_name,
#       start_file          => $start_file, 
#       process_file        => $process_file,
#       package_source_file => 'puppet:///modules/pyapp/nbs-integration/nbs1.0/HostAgent',
#       service             => 'nbs-ha-integration',
#       service_source_file => $service_source_file,
#       config_file         => $config_file,
#       config_source_file  => "puppet:///modules/pyapp/nbs-integration/nbs1.0/HostAgent/conf/conf/integration/199.11/hostagent-default.ini"
#
#    }
}

