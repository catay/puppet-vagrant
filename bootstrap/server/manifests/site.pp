
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


# Set static host entries for the master of masters.

if $trusted['certname'] =~ /^mom.example.com/ {

  host {$facts['networking']['fqdn']: 
    ensure        => present,
    host_aliases  => ["${facts['networking']['hostname']}", "puppet" ],
    ip            => $facts['networking']['interfaces']['eth1']['ip']
  }

}

# Set static host entries for the compile masters.

if $trusted['certname'] =~ /^c\d\d.example.com/ {

  host {$facts['networking']['fqdn']: 
    ensure        => present,
    host_aliases  => ["${facts['networking']['hostname']}"],
    ip            => $facts['networking']['interfaces']['eth1']['ip']
  }

  host {"mom.example.com": 
    ensure        => present,
    host_aliases  => ["mom", "puppet" ],
    ip            => "${facts['vagrant']['subnet']}.5"  
  }

}

# Downsize the JVM memory requirements for the puppet server.

augeas {"puppetserver":
        context => "/files/etc/sysconfig/puppetserver",
        changes => [
                "set JAVA_ARGS '\"-Xms512m -Xmx512m -XX:MaxPermSize=64m\"'"
        ]
}
