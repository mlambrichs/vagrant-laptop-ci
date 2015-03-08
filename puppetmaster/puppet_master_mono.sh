#!/usr/bin/env bash
#

set -e
if [ "$EUID" -ne "0" ]; then
  echo "This script must be run as root." >&2
  exit 1
fi
echo "------- Setup Puppet Master Extras -------"
echo "192.168.33.21 pe-agent-development.sc-ict.intranet" >> /etc/hosts
echo "192.168.33.22 pe-agent-test.sc-ict.intranet" >> /etc/hosts
echo "192.168.33.23 pe-agent-acceptance.sc-ict.intranet" >> /etc/hosts
echo "192.168.33.24 pe-agent-production.sc-ict.intranet" >> /etc/hosts
echo "192.168.33.12 laptop-buildserver.sc-ict.intranet" >> /etc/hosts
echo "PATH=$PATH:/opt/puppet/bin:/usr/local/bin" >> /root/.bash_profile
.  /root/.bash_profile
echo "----------- Installing GIT ---------------"
yum install -y git
echo "----------- Done installing GIT ----------"
echo "----------- Installing r10k --------------"
puppet module install zack/r10k --modulepath=/opt/puppet/share/puppet/modules
echo "----------- Done installing r10k ---------"
echo "-- Done installing Puppet Master Extras --"