# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.network :private_network, ip: "10.10.10.10"

  config.ssh.forward_agent = true

  config.vm.synced_folder "./", "/vagrant", :nfs => true

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", "2048"]
  end

  config.vm.provision "shell", path: "./provisioning.sh"

  config.vm.provider "virtualbox" do |v|
    v.name = "symfonydev"
  end
end
