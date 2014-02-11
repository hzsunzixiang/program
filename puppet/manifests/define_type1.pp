#Duplicate declaration: File[.plan] is already declared in file /etc/puppet/manifests/define_type1.pp at line 9; cannot redeclare at /etc/puppet/manifests/define_type1.pp:9 on node 10-160-162-45.novalocal
   define planfile ($user = $title, $content) {
      file {'.plan':
        path    => "/home/${user}/.plan",
        ensure  => file,
        content => $content,
        mode    => 0644,
        owner   => $user,
        require => User[$user],
      }
    }

    planfile {'nick':
      content => "Working on new Learning Puppet chapters. Tomorrow: upgrading the LP virtual machine.",
    }

    planfile {'chris':
      content => "Resurrecting a very dead laptop.",
    }
