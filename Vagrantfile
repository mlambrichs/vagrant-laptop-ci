VAGRANTFILE_API_VERSION = "2"

require 'yaml'

# Necessary shell cmdl's
$install_puppet_on_client = <<END
curl -k https://puppetmaster:8140/packages/current/install.bash | sudo bash
END
$install_r10k = <<END
/opt/puppet/bin/gem install r10k
END

# Check plugins
plugins = ["vagrant-hosts", "vagrant-pe_build", "vagrant-vbguest"]
plugins.each do |plugin|
  unless Vagrant.has_plugin?(plugin)
    raise plugin << " has not been installed."
  end
end

# Read YAML file with server and box details
servers = YAML.load_file('servers.yaml')
boxes = YAML.load_file('boxes.yaml')

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.pe_build.download_root = 'https://s3.amazonaws.com/pe-builds/released/3.7.1'
  config.pe_build.version       = '3.7.1'
  config.pe_build.filename      = 'puppet-enterprise-3.7.1-el-6-x86_64.tar.gz'

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
      if server["synced_folders"]
        server["synced_folders"].each do |folder|
          srv.vm.synced_folder folder["src"], folder["dst"]
        end
      end

      if server["role"].eql? "master"
        # Setup PE
        srv.vm.provision :pe_bootstrap do |provisioner|
          provisioner.answer_file = server["answers"]
          provisioner.role = server["role"]
        end
        srv.vm.provision :shell, inline: $install_r10k
      else 
        srv.vm.provision :shell, inline: $install_puppet_on_client
      end
    end
  end
end
