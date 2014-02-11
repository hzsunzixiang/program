# /etc/puppet/manifests/nodes.pp

node basenode {
  include sudo
}

node 'web.example.com' inherits basenode {
}
