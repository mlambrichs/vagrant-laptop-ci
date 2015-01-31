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
cp /vagrant/puppet-enterprise-3.7.1-el-7-x86_64.tar.gz /var/tmp
cd /var/tmp
tar zxf puppet-enterprise-3.7.1-el-7-x86_64.tar.gz
cp /vagrant/puppet-enterprise-uninstaller /var/tmp/puppet-enterprise-3.7.1-el-7-x86_64/
cd /var/tmp/puppet-enterprise-3.7.1-el-7-x86_64
./puppet-enterprise-uninstaller -a /vagrant/uninstall_answers.txt
./puppet-enterprise-installer -a /vagrant/answers.txt
ln -s /usr/local/bin/puppet /usr/bin/puppet
echo "Puppet installed!"