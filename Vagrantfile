VAGRANTFILE_API_VERSION = "2"

require 'yaml'

plugins = ["vagrant-hosts", "vagrant-pe_build", "vagrant-vbguest"]
plugins.each do |plugin|
  unless Vagrant.has_plugin?(plugin)
    raise plugin << " has not been installed."
  end
end

# Read YAML file with box details
servers = YAML.load_file('servers.yaml')
boxes = YAML.load_file('boxes.yaml')

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.pe_build.download_root = 'https://s3.amazonaws.com/pe-builds/released/3.7.1'
  config.pe_build.version       = '3.7.1'
  config.pe_build.filename      = 'puppet-enterprise-3.7.1-e1-7-x86_64.tar.gz'

  servers.each do |server|

    config.vm.define server["name"] do |srv|
      config.vm.hostname                = server["hostname"]
      srv.vm.box                        = server["box"]
      srv.vm.box_url                    = boxes[server["box"]]["url"]
      srv.vm.box_download_checksum_type = "md5"
      srv.vm.box_download_checksum      = boxes[server["box"]]["checksum"]
      srv.vm.provider :virtualbox do |vb|
        vb.name = server["name"]
        vb.memory = server["ram"]
      end
      srv.vm.network "private_network", ip: server["ip"]

      if server["ports"]
        server["ports"].each do |port|
          srv.vm.network "forwarded_port", guest: port["guest"], host: port["host"]
        end
      end
      srv.vm.provision :hosts

      # Setup PE
      srv.vm.provision :pe_bootstrap do |provisioner|
        provisioner.answer_file = server["answers"]
        provisioner.role = server["role"]
      end
    end
  end
end
