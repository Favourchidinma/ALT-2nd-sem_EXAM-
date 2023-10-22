#!/bin/bash

vagrant init ubuntu/focal64

cat << EOF > Vagrantfile
Vagrant.configure("2") do |config|
  # Define the 'Slave' VM
  
  config.vm.define "slave" do |slave|
    slave.vm.hostname = "slave"
    slave.vm.box = "ubuntu/focal64"
    slave.vm.network "private_network", ip: "192.168.20.31"

    slave.vm.provision "shell", inline: <<-SHELL
      sudo apt-get update && sudo apt-get upgrade -y
      sudo apt-get install -y avahi-daemon libnss-mdns
    SHELL
  end

  config.vm.define "master" do |master|
    master.vm.hostname = "master"
    master.vm.box = "ubuntu/focal64"
    master.vm.network "private_network", ip: "192.168.20.30"

    master.vm.provision "shell", inline: <<-SHELL
      sudo apt-get update && sudo apt-get upgrade -y
      sudo apt-get install -y avahi-daemon libnss-mdns
    SHELL
  end

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "512"
    vb.cpus = "1"
  end
end
EOF

vagrant up
