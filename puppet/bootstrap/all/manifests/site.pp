
# Set puppet fqdn and alias in hosts file

host {'puppet.example.net': 
  ensure        => present,
  host_aliases  => 'puppet',
  ip            => $facts['networking']['interfaces']['eth1']['ip']
}
