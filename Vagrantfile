# -*- mode: ruby -*-
# vi: set ft=ruby :

### Install Node.js / npm /grunt in the Vagrant-Box ###
# npm install
# start grunt and watcher
# grunt

Vagrant.configure(2) do |config|
  config.vm.box = "debian/contrib-jessie64"

  config.vm.network "private_network", ip: "10.10.10.10"
  config.ssh.forward_agent = true
  config.vm.synced_folder "./", "/var/www/", :nfs => false

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
    vb.customize "post-boot",["controlvm", :id, "setlinkstate1", "on"]
  end

  config.vm.provision "shell", path: "scripts/bootstrap.sh"
end
