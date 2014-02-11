# /etc/puppet/manifests/modules.pp

node default {
  package {
	  "oracle-j2sdk1.6":
	  ensure => installed;
	}
}
