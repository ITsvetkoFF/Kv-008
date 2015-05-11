# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.require_version ">= 1.7.0"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "iodose/eco_ubuntu"
  config.vm.network :forwarded_port, guest: 8000, host: 8000
  config.vm.network :forwarded_port, guest: 5432, host: 8002
  config.vm.synced_folder "./ecomap", "/project_data"
  config.ssh.private_key_path = '.vagrant/machines/default/virtualbox/private_key'
  config.ssh.insert_key = false
  # line:
  # source /home/vagrant/venv/bin/activate
  # was added to ~/.bashrc file
end
  
