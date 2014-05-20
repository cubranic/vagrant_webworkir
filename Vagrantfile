# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # A standard Ubuntu 12.04 LTS 64-bit box
  config.vm.box = "hashicorp/precise64"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "forwarded_port", id: "http", guest: 80, host: 8888

  # Provision using the shell script "bootstrap.sh"
  config.vm.provision "shell" do |s|
    s.privileged = true         # run as 'root'
    s.path = "bootstrap.sh"
  end
end
