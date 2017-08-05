
# Set loopback, FQDN and short host name in hosts file.

host {"localhost": 
  ensure        => present,
  host_aliases  => ["localhost.localdomain", "localhost4", "localhost4.localdomain4" ],
  ip            => '127.0.0.1'
}

host {"localhost6": 
  ensure        => present,
  host_aliases  => ["localhost.localdomain", "localhost", "localhost6.localdomain6" ],
  ip            => '::1'
}

# Set static host entries for a regular puppet node.

host {$facts['networking']['fqdn']: 
  ensure        => present,
  host_aliases  => ["${facts['networking']['hostname']}"],
  ip            => $facts['networking']['interfaces']['eth1']['ip']
}

host {"mom.example.com": 
  ensure        => present,
  host_aliases  => ["mom"],
  ip            => "${facts['vagrant']['subnet']}.5"  
}

# Loop over the compile masters fact and create a host entry.
# Randomly assign the 'puppet' alias to a compile master.

$facts['vagrant']['compile_masters'].each |Integer $i, String $cm| {

  # derive ip index last octet from compile master fqdn
  
  $cm_ip_suffix = regsubst($cm,'^.+[0-9]([0-9])\.example.com','\1')

  # generate a random number based on the count of compile masters
 
  $r = fqdn_rand($facts['vagrant']['compile_masters_count'])

  # if the random number matches the array index, set the puppet alias

  if $r == $i {
    $cm_aliases = [regsubst($cm,'^(.+)\.example.com','\1'), "puppet"]
  } else {
    $cm_aliases = [regsubst($cm,'^(.+)\.example.com','\1')]
  }

  # declare compile master host resource

  host {"${cm}":
    ensure        => present,
    host_aliases  => $cm_aliases,
    ip            => "${facts['vagrant']['subnet']}.1${cm_ip_suffix}"
  }

}


