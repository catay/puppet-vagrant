# -*- mode: ruby -*-
# vi: set ft=ruby :

# Globals

SUBNET_PRIVATE_NETWORK="192.168.99"


Vagrant.configure(2) do |config|

  # define server puppet01

  config.vm.define "puppet01" do |puppet01|

    # Set the Vagrant box.
    puppet01.vm.box = "centos/7"

    # Set the hostname of the server.
    puppet01.vm.hostname = "puppet01.example.net"

    # Set the memory of the server.
    puppet01.vm.provider "virtualbox" do |vb| 
      vb.memory = "512"
    end

    # Create a private network, which allows host-only access to the machine
    # using a specific IP.
    config.vm.network "private_network", ip: "192.168.99.10"

  end

end
