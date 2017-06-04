# -*- mode: ruby -*-
# vi: set ft=ruby :

## Globals ##

SUBNET_PRIVATE_NETWORK="192.168.99"

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

  # Define server puppet01.

  config.vm.define "puppet01" do |puppet01|

    # Set the Vagrant box.
    puppet01.vm.box = "centos/7"

    # Set the hostname of the server.
    puppet01.vm.hostname = "puppet01.example.net"

    # Set the memory of the server.
    puppet01.vm.provider "virtualbox" do |vb| 
      vb.memory = "1024"
    end

    # Create a private network, which allows host-only access to the machine
    # using a specific IP.
    puppet01.vm.network "private_network", ip: "192.168.99.10"

    # Provision server.
    puppet01.vm.provision "shell", inline: $puppetserver_install

    puppet01.vm.provision "puppet" do |puppet|
      puppet.binary_path = "/opt/puppetlabs/bin"
      #puppet.manifests_path = "puppet/manifests"
      #puppet.manifest_file = "bootstrap_puppetserver.pp"
      puppet.environment = "all" 
      puppet.environment_path = 'puppet/bootstrap'
      puppet.synced_folder_type = "rsync"
      puppet.options = "--verbose --debug"
    end

  end

  # Define server puppet02.

  config.vm.define "puppet02" do |puppet02|

    # Set the Vagrant box.
    puppet02.vm.box = "centos/7"

    # Set the hostname of the server.
    puppet02.vm.hostname = "puppet02.example.net"

    # Set the memory of the server.
    puppet02.vm.provider "virtualbox" do |vb| 
      vb.memory = "1024"
    end

    # Create a private network, which allows host-only access to the machine
    # using a specific IP.
    puppet02.vm.network "private_network", ip: "192.168.99.11"

    # Provision server.
    puppet02.vm.provision "shell", inline: $puppetserver_install

    puppet02.vm.provision "puppet" do |puppet|
      puppet.binary_path = "/opt/puppetlabs/bin"
      #puppet.manifests_path = "puppet/manifests"
      #puppet.manifest_file = "bootstrap_puppetserver.pp"
      puppet.environment = "all" 
      puppet.environment_path = 'puppet/bootstrap'
      puppet.synced_folder_type = "rsync"
      puppet.options = "--verbose --debug"
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
      #puppet.manifests_path = "puppet/manifests"
      #puppet.manifest_file = "bootstrap_puppetserver.pp"
      puppet.environment = "agent" 
      puppet.environment_path = 'bootstrap'
      puppet.synced_folder_type = "rsync"
      puppet.options = "--verbose --debug"
    end

  end

end
