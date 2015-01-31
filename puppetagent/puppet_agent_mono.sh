#!/usr/bin/env bash
#
# This bootstraps Puppet on CentOS 7.
#
#set -e
if [ "$EUID" -ne "0" ]; then
  echo "This script must be run as root." >&2
  exit 1
fi
systemctl status firewalld.service |grep inactive >/dev/null 
if [ $? != 0 ];
    then 
	echo "-------- Kill Firewall -------------------"
	echo "------------------------------------------"
	systemctl stop firewalld.service 2>/dev/null
	systemctl disable firewalld.service 2>/dev/null
fi

# Install Puppet
echo "Installing Puppet..."
export PATH=$PATH:/usr/local/bin
echo "192.168.33.10 laptop-puppet-master.sc-ict.intranet" >> /etc/hosts
echo "192.168.33.11 laptop-puppet-agent.sc-ict.intranet" >> /etc/hosts
curl -k https://laptop-puppet-master.sc-ict.intranet:8140/packages/current/install.bash | sudo bash
ln -s /usr/local/bin/puppet /usr/bin/puppet
echo "Puppet installed!"