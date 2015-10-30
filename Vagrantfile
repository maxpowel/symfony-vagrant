Vagrant.configure(2) do |config|
  config.vm.box = "puppetlabs/ubuntu-14.04-64-puppet"

  config.vm.network "private_network", ip: "192.168.50.4"

  config.vm.synced_folder "/Users/maxpowel/app", "/var/www/symfony", type: "nfs"

  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
  end

  config.vm.provision "puppet" do |puppet|
    puppet.options = "--verbose --debug"
    puppet.hiera_config_path = "hiera.yaml"
    puppet.environment_path = "environments"
    puppet.environment = "dev"
    puppet.module_path = "modules"
  end
end
