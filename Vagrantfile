# -*- mode: ruby -*-
# vi: set ft=ruby :

## Globals ##

SUBNET_PRIVATE_NETWORK="192.168.99"
MAX_PUPPET_SERVERS=2
MAX_PUPPET_NODES=1

## Inline Shell scripts ##

$puppetserver_install = <<SCRIPT
yum -y localinstall https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
yum -y install puppetserver
# downsize the JVM memory requirements for the puppet server
sed -i -e 's/2g/512m/g' -e 's/256m/64m/g' /etc/sysconfig/puppetserver
SCRIPT

$puppetagent_install = <<SCRIPT
yum -y localinstall https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
yum -y install puppet-agent
SCRIPT

## Vagrant definitions ##

Vagrant.configure(2) do |config|

  # Define Puppet servers
 
  (1..MAX_PUPPET_SERVERS).each do |i|

    config.vm.define "puppet%02d" % [i] do |puppet_server|

      # Set the Vagrant box.
      puppet_server.vm.box = "centos/7"
  
      # Set the hostname of the server.
      puppet_server.vm.hostname = "puppet%02d.example.net" % i
  
      # Set the memory of the server.
      puppet_server.vm.provider "virtualbox" do |vb| 
        vb.memory = "1024"
      end
  
      # Create a private network, which allows host-only access to the machine
      # using a specific IP.
      puppet_server.vm.network "private_network", ip: "192.168.99.1#{i}"
  
      # Provision server.
      puppet_server.vm.provision "shell", inline: $puppetserver_install
  
      puppet_server.vm.provision "puppet" do |puppet|
        puppet.binary_path = "/opt/puppetlabs/bin"
        puppet.environment = "server" 
        puppet.environment_path = 'bootstrap'
        puppet.synced_folder_type = "rsync"
        puppet.options = "--verbose --debug"
      end

    end

  end

  # Define server node01.

  config.vm.define "node01" do |node01|

    # Set the Vagrant box.
    node01.vm.box = "centos/7"

    # Set the hostname of the server.
    node01.vm.hostname = "node01.example.net"

    # Set the memory of the server.
    node01.vm.provider "virtualbox" do |vb| 
      vb.memory = "512"
    end

    # Create a private network, which allows host-only access to the machine
    # using a specific IP.
    node01.vm.network "private_network", ip: "192.168.99.20"

    # Provision server.
    node01.vm.provision "shell", inline: $puppetagent_install

    node01.vm.provision "puppet" do |puppet|
      puppet.binary_path = "/opt/puppetlabs/bin"
      puppet.environment = "agent" 
      puppet.environment_path = 'bootstrap'
      puppet.synced_folder_type = "rsync"
      puppet.options = "--verbose --debug"
    end

  end

end
