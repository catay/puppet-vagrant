# -*- mode: ruby -*-
# vi: set ft=ruby :

## Globals ##

DEBUG_PROVISIONING=false
SUBNET_PRIVATE_NETWORK="192.168.99"
MAX_PUPPET_COMPILE_SERVERS=2
MAX_PUPPET_NODES=1

# If debug is enabled, give more verbose output when installing
# packages and during puppet apply.

if DEBUG_PROVISIONING
  YUM_OPTIONS="-y"
  PUPPET_OPTIONS="--verbose --debug"
else
  YUM_OPTIONS="-y -q"
  PUPPET_OPTIONS=""
end

## Inline Shell scripts ##

$puppetserver_install = <<SCRIPT
yum #{YUM_OPTIONS} localinstall https://yum.puppetlabs.com/puppet5/puppet5-release-el-7.noarch.rpm
yum #{YUM_OPTIONS} install puppetserver
SCRIPT

$puppetagent_install = <<SCRIPT
yum #{YUM_OPTIONS} localinstall https://yum.puppetlabs.com/puppet5/puppet5-release-el-7.noarch.rpm
yum #{YUM_OPTIONS} install puppet-agent
SCRIPT

$puppet_custom_facts = <<SCRIPT
mkdir -p /etc/puppetlabs/facter/facts.d
echo "vagrant:" > /etc/puppetlabs/facter/facts.d/vagrant.yaml
echo "  subnet: #{SUBNET_PRIVATE_NETWORK}" >> /etc/puppetlabs/facter/facts.d/vagrant.yaml
echo "  compile_masters_count: #{MAX_PUPPET_COMPILE_SERVERS}" >> /etc/puppetlabs/facter/facts.d/vagrant.yaml
echo "  compile_masters:" >> /etc/puppetlabs/facter/facts.d/vagrant.yaml
seq -f "%02.f" #{MAX_PUPPET_COMPILE_SERVERS} | awk '{print "   - c"$0".example.com"}' >> /etc/puppetlabs/facter/facts.d/vagrant.yaml 
SCRIPT

## Vagrant definitions ##

Vagrant.configure(2) do |config|

  # Define the master of masters (MoM)

  config.vm.define "mom" do |mom|

    # Set the Vagrant box.
    mom.vm.box = "centos/7"

    # Set the hostname of the server.
    mom.vm.hostname = "mom.example.com"

    # Set the memory of the server.
    mom.vm.provider "virtualbox" do |vb| 
      vb.memory = "1024"
    end

    # Create a private network, which allows host-only access to the machine
    # using a specific IP.
    mom.vm.network "private_network", ip: "#{SUBNET_PRIVATE_NETWORK}.5"

    # Provision server.
    mom.vm.provision "shell", inline: $puppetserver_install

    mom.vm.provision "puppet" do |puppet|
      puppet.binary_path = "/opt/puppetlabs/bin"
      puppet.environment = "server" 
      puppet.environment_path = 'bootstrap'
      puppet.synced_folder_type = "rsync"
      puppet.options = "#{PUPPET_OPTIONS}"
    end

  end

  # Define Puppet compile servers
 
  (1..MAX_PUPPET_COMPILE_SERVERS).each do |i|

    config.vm.define "c%02d" % [i] do |compile_server|

      # Set the Vagrant box.
      compile_server.vm.box = "centos/7"
  
      # Set the hostname of the server.
      compile_server.vm.hostname = "c%02d.example.com" % i
  
      # Set the memory of the server.
      compile_server.vm.provider "virtualbox" do |vb| 
        vb.memory = "1024"
      end
  
      # Create a private network, which allows host-only access to the machine
      # using a specific IP.
      compile_server.vm.network "private_network", ip: "#{SUBNET_PRIVATE_NETWORK}.1#{i}"
  
      # Provision server.
      compile_server.vm.provision "shell", inline: $puppetserver_install
      compile_server.vm.provision "shell", inline: $puppet_custom_facts
  
      compile_server.vm.provision "puppet" do |puppet|
        puppet.binary_path = "/opt/puppetlabs/bin"
        puppet.environment = "server" 
        puppet.environment_path = 'bootstrap'
        puppet.synced_folder_type = "rsync"
        puppet.options = "#{PUPPET_OPTIONS}"
      end

    end

  end

  # Define Puppet node servers

  (1..MAX_PUPPET_NODES).each do |i|

    config.vm.define "n%02d" % [i] do |puppet_node|

      # Set the Vagrant box.
      puppet_node.vm.box = "centos/7"

      # Set the hostname of the server.
      puppet_node.vm.hostname = "n%02d.example.com" % i

      # Set the memory of the server.
      puppet_node.vm.provider "virtualbox" do |vb| 
        vb.memory = "512"
      end

      # Create a private network, which allows host-only access to the machine
      # using a specific IP.
      puppet_node.vm.network "private_network", ip: "#{SUBNET_PRIVATE_NETWORK}.2#{i}"

      # Provision server.
      puppet_node.vm.provision "shell", inline: $puppetagent_install
      puppet_node.vm.provision "shell", inline: $puppet_custom_facts

      puppet_node.vm.provision "puppet" do |puppet|
        puppet.binary_path = "/opt/puppetlabs/bin"
        puppet.environment = "agent" 
        puppet.environment_path = 'bootstrap'
        puppet.synced_folder_type = "rsync"
        puppet.options = "#{PUPPET_OPTIONS}"
      end

    end

  end

end
