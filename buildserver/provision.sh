#!/bin/bash


echo "-------- Set Locale en_US.utf8 -----------"
echo "------------------------------------------"
echo "LANG="en_US.utf8"" > /etc/locale.conf
echo "LC_CTYPE="en_US.utf8"" >> /etc/locale.conf 

systemctl status firewalld.service |grep inactive 
if [ $? != 0 ];
    then 
	echo "-------- Kill Firewall -------------------"
	echo "------------------------------------------"
	systemctl stop firewalld.service
	systemctl disable firewalld.service
fi

if [ ! -f /usr/bin/java ]; 
then
	echo "-------- PROVISIONING JAVA ---------------"
	echo "------------------------------------------"
    yum -y install java-1.7.0-openjdk.x86_64

else
	echo "CHECK - Java already installed"
fi

if [ ! -f /usr/bin/wget ]; 
then
	echo "-------- PROVISIONING WGET ---------------"
	echo "------------------------------------------"
    yum -y install wget

else
	echo "CHECK - Wget already installed"
fi


if [ ! -f /usr/sbin/tomcat ]; 
then
	echo "-------- PROVISIONING TOMCAT ------------"
	echo "-----------------------------------------" 
	yum install -y install tomcat 
	# run tomcat as root because we don't care and it fixes the shared folder issue
	# sed -i 's/TOMCAT_USER=.*/TOMCAT_USER="root"/' /etc/tomcat/tomcat.conf
    grep JENKINS_HOME /etc/tomcat/context.xml
    if [ $? != 0 ];
    then 
    	sed -i '/<\/Context>/d' /etc/tomcat/context.xml
    	echo "<Environment name="JENKINS_HOME" value="/var/lib/tomcat/webapps/jenkins/" type="java.lang.String"/>" >> /etc/tomcat/context.xml
    	echo "</Context>" >> /etc/tomcat/context.xml   
    fi
    systemctl enable tomcat.service
    systemctl start tomcat.service
    systemctl status tomcat.service
else
	echo "CHECK - Tomcat already installed"
fi


if [ ! -f /var/lib/tomcat/webapps/jenkins.war ]; 
then
	echo "-------- PROVISIONING JENKINS ------------"
	echo "------------------------------------------"
    wget -q -O /var/lib/tomcat/webapps/jenkins.war http://mirrors.jenkins-ci.org/war/latest/jenkins.war
    systemctl restart tomcat.service
    sleep 60 
else
	echo "CHECK - Jenkins already installed"
fi


if [ ! -f /var/lib/tomcat/webapps/gitblit.war ]; 
then
	echo "-------- PROVISIONING GITBLIT ---------------"
	echo "------------------------------------------"
    wget  -q -O /var/lib/tomcat/webapps/gitblit.war http://dl.bintray.com/gitblit/releases/gitblit-1.6.2.war
    systemctl restart tomcat.service
    sleep 60
else
	echo "CHECK - GitBlit already installed"
fi


echo "-------- RESTARTING TOMCAT ---------------"
echo "------------------------------------------"
systemctl restart tomcat.service


# echo "-------- Check for Updates ---------------"
# echo "------------------------------------------"
# yum -y update |grep "No Packages marked for Update"
# if [ $? != 0 ];
# then 
# 	echo "reboot"
# else
# 	echo "System Up to Date!"
# fi

