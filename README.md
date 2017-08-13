# Puppet Vagrant environment

## Introduction

This *multi-machine* Vagrant environment will bootstrap a set of virtual
machines with Puppet 5 preinstalled on it. 

* mom.example.com
* c01.example.com
* c02.example.com
* n01.example.com

## Usage

Clone the repository to your system.

``
git clone git@github.com:catay/puppet-vagrant.git
``

Start the *multi-machine* environment.

``
$ vagrant up
``

## Configuration

A set of global variables in the the Vagrantfile can be configured to
change the configuration.

|variable                  | function                                        |
|--------------------------|-------------------------------------------------|
|DEBUG_PROVISIONING        | Enable/disable provisioning debug output.       |
|SUBNET_PRIVATE_NETWORK    | Configure different subnet prefix.              |
|MAX_PUPPET_COMPILE_SERVERS| Configure the amount of compile Puppet servers. |
|MAX_PUPPET_NODES          | Configure the amount of regular Puppet nodes.   |
