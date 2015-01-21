#!/bin/bash

echo "-------- Check for Updates ---------------"
echo "------------------------------------------"
#yum -y update

if [ ! -f /usr/bin/java ]; 
then
	echo "-------- PROVISIONING JAVA ---------------"
	echo "------------------------------------------"
    yum -y install java-1.7.0-openjdk.x86_64

else
	echo "CHECK - Java already installed"
fi

if [ ! -f /etc/init.d/tomcat6 ]; 
then
	echo "-------- PROVISIONING TOMCAT ------------"
	echo "-----------------------------------------" 
	yum install -y install tomcat6 
	# run tomcat as root because we don't care and it fixes the shared folder issue
	sed -i 's/TOMCAT_USER=.*/TOMCAT_USER="root"/' /etc/init.d/tomcat6
else
	echo "CHECK - Tomcat already installed"
fi

if [ ! -f /var/lib/tomcat6/webapps/jenkins.war ]; 
then
	echo "-------- PROVISIONING JENKINS ------------"
	echo "------------------------------------------"
    wget -q -O /var/lib/tomcat6/webapps/jenkins.war http://mirrors.jenkins-ci.org/war/latest/jenkins.war
    sed -i '/<\/Context>/d' /etc/tomcat6/context.xml
    echo "<Environment name="JENKINS_HOME" value="/var/lib/tomcat6/webapps/jenkins/" type="java.lang.String"/>" >> /etc/tomcat6/context.xml
    echo "</Context>" >> /etc/tomcat6/context.xml   
    service tomcat6 restart
    sleep 60 
else
	echo "CHECK - Jenkins already installed"
fi

if [ ! -f /var/lib/tomcat6/webapps/gitblit.war ]; 
then
	echo "-------- PROVISIONING GITBLIT ---------------"
	echo "------------------------------------------"
    wget  -q -O /var/lib/tomcat6/webapps/gitblit.war http://dl.bintray.com/gitblit/releases/gitblit-1.6.2.war
    service tomcat6 restart
    sleep 60
else
	echo "CHECK - GitBlit already installed"
fi
	echo "-------- RESTARTING TOMCAT ---------------"
	echo "------------------------------------------"
    sleep 60
    service tomcat6 restart