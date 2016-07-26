# -*- mode: ruby -*-
# vi: set ft=ruby :

# Copyright 2016 Rich Haase
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "centos/7"
  config.vm.synced_folder ".", "/home/vagrant/sync", type: "rsync", rsync__exclude: ".git/"
  config.vm.provision :shell, :path => "bin/bootstrap.sh"
  config.vm.network "forwarded_port", guest: 19888, host: 19888

  config.vm.define :demo do |demo|
    demo.vm.hostname = "demo"
    demo.vm.network :private_network, ip: "192.168.50.101"
    demo.vm.provider "virtualbox" do |v|
      v.memory = 4096
    end
  end
  
  config.ssh.forward_agent = true
  
end
