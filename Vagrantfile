# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "centos/7"

  config.vm.provision :shell, :path => "bin/bootstrap.sh"

  config.vm.define :hadoop do |hadoop|
    hadoop.vm.hostname = "hadoop"
    hadoop.vm.network :private_network, ip: "192.168.50.101"
    hadoop.vm.provider "virtualbox" do |v|
      v.memory = 4096
    end
  end

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing .nethost:8080" will access port 80 on the guest machine.
  # config.vm.network :forwarded_port, guest: 80, host: 8080

  # Create a private.network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network :private.network, ip: "192.168.33.10"

  # Create a public.network, which generally matched to bridged.network.
  # Bridged.networks make the machine appear as another physical device on
  # your.network.
  # config.vm.network :public.network

  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  config.ssh.forward_agent = true
end