Vagrant.require_plugin "vagrant-sshfs"

Vagrant.configure("2") do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  config.sshfs.paths = { "/home/vagrant/src" => "mountpoint" }
end
