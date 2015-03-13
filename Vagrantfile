VAGRANTFILE_API_VERSION = "2"

require 'yaml'

# Read YAML file with box details
servers = YAML.load_file('servers.yaml')
boxes = YAML.load_file('boxes.yaml')

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vbguest.auto_update = true # check correct additions version when booting
  config.vbguest.no_remote = false  # allow downloading the iso from a webserver
  config.vbguest.iso_path  = http://download.virtualbox.org/virtualbox/%{version}/VBoxGuestAdditions_%{version}.iso

  servers.each do |servers|
    config.vm.define servers["name"] do |srv|
      config.vm.hostname                  = servers["hostname"]
        srv.vm.box                        = servers["box"]
        srv.vm.box_url                    = boxes[servers["box"]]["url"]
        srv.vm.box_download_checksum_type = "md5"
        srv.vm.box_download_checksum      = boxes[servers["box"]]["checksum"]
        srv.vm.provider :virtualbox do |vb|
          vb.name = servers["name"]
          vb.memory = servers["ram"]
        end
  
        config.vm.network "private_network", ip: servers["ip"]
        if servers["ports"]
          servers["ports"].each do |port|
  	  srv.vm.network "forwarded_port", guest: port["guest"], host: port["host"]
          end
        end
    end
  end
end
