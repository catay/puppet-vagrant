
# Set puppet fqdn and alias in hosts file

host {'puppet01.example.net': 
  ensure        => present,
  host_aliases  => ['puppet', 'puppet01'],
  ip            => '192.168.99.10' 
}

host {$facts['networking']['fqdn']: 
  ensure        => present,
  host_aliases  => $facts['networking']['hostname'],
  ip            => $facts['networking']['interfaces']['eth1']['ip']
}
