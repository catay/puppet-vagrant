
# Set FQDN and short host name in hosts file.
# For a Puppet Server we also set 'puppet' as a host alias.

host {$facts['networking']['fqdn']: 
  ensure        => present,
  host_aliases  => ["${facts['networking']['hostname']}", "puppet" ]
  ip            => $facts['networking']['interfaces']['eth1']['ip']
}

