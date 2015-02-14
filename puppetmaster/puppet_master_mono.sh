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
	systemctl stop firewalld.service 2>/dev/null
	systemctl disable firewalld.service 2>/dev/null
fi

# Install Puppet
echo "----------- Installing Puppet ------------"
export PATH=$PATH:/usr/local/bin
echo "192.168.33.10 laptop-puppet-master.sc-ict.intranet" >> /etc/hosts
echo "192.168.33.11 laptop-puppet-agent.sc-ict.intranet" >> /etc/hosts
cp /vagrant/puppet-enterprise-3.7.1-el-7-x86_64.tar.gz /var/tmp
cd /var/tmp
tar zxf puppet-enterprise-3.7.1-el-7-x86_64.tar.gz
cp /vagrant/puppet-enterprise-uninstaller /var/tmp/puppet-enterprise-3.7.1-el-7-x86_64/
cd /var/tmp/puppet-enterprise-3.7.1-el-7-x86_64
./puppet-enterprise-uninstaller -a /vagrant/uninstall_answers.txt
./puppet-enterprise-installer -a /vagrant/answers.txt
ln -s /usr/local/bin/puppet /usr/bin/puppet
export PATH=$PATH:/opt/puppet/bin
echo "----------- Puppet installed -------------"
echo "----------- Installing GIT ---------------"
yum install -y git
echo "----------- Done installing GIT ----------"
echo "----------- Installing r10k --------------"
#/opt/puppet/bin/gem install r10k
puppet module install zack/r10k
echo "----------- Done installing r10k ---------"
echo "----------- Done installing Puppet Master "