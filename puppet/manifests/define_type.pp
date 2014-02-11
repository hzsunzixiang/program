 define planfile ($user = $title, $content) {
      file {"/home/${user}/.plan":
        ensure  => file,
        content => $content,
        mode    => 0644,
        owner   => $user,
        require => User[$user],
      }
    }

    user {'nick':
      ensure     => present,
      managehome => true,
      uid        => 517,
    }
    planfile {'nick':
      content => "Working on new Learning Puppet chapters. Tomorrow: upgrading the LP virtual machine.",
    }
