#!/usr/bin/env bash
#
# This bootstraps Puppet on CentOS 7.
#
#set -e
if [ "$EUID" -ne "0" ]; then
  echo "This script must be run as root." >&2
  exit 1
fi

# Install Puppet
echo "--------- Setup Puppet Agentnode ---------"
export PATH=$PATH:/usr/local/bin
echo "192.168.33.10 laptop-puppet-master.sc-ict.intranet" >> /etc/hosts
echo "192.168.33.21 pe-agent-development.sc-ict.intranet" >> /etc/hosts
echo "192.168.33.22 pe-agent-test.sc-ict.intranet" >> /etc/hosts
echo "192.168.33.23 pe-agent-acceptance.sc-ict.intranet" >> /etc/hosts
echo "192.168.33.24 pe-agent-production.sc-ict.intranet" >> /etc/hosts
sed -i '/.*PATH*.*/d' .bash_profile
echo "export PATH=$PATH:/opt/puppet/bin:/usr/local/bin:$HOME/bin" >> /root/.bash_profile
curl -k https://laptop-puppet-master.sc-ict.intranet:8140/packages/current/install.bash | sudo bash
echo "------- Puppet Agentnode Installed -------"