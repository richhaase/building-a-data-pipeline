# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "centos/7"
  config.vm.synced_folder ".", "/home/vagrant/demo"
  config.vm.provision :shell, :path => "bin/bootstrap.sh"

  config.vm.define :demo do |demo|
    demo.vm.hostname = "demo"
    demo.vm.network :private_network, ip: "192.168.50.101"
    demo.vm.provider "virtualbox" do |v|
      v.memory = 4096
    end
  end
  
  config.ssh.forward_agent = true
  
end
