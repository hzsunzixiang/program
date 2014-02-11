# /etc/puppet/modules/sudo/manifests/sudo.pp

class sudo {
    file { "/etc/sudoers":
        owner => "root",
        group => "root",
        mode  => 440,
    }
}
