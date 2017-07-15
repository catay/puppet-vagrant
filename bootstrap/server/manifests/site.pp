
# Set FQDN and short host name in hosts file.
# For a Puppet Server we also set 'puppet' as a host alias.

host {$facts['networking']['fqdn']: 
  ensure        => present,
  host_aliases  => ["${facts['networking']['hostname']}", "puppet" ],
  ip            => $facts['networking']['interfaces']['eth1']['ip']
}

# Downsize the JVM memory requirements for the puppet server.

augeas {"puppetserver":
        context => "/files/etc/sysconfig/puppetserver",
        changes => [
                "set JAVA_ARGS '\"-Xms512m -Xmx512m -XX:MaxPermSize=64m\"'"
        ]
}
