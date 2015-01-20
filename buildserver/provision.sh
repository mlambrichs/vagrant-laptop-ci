#!/bin/bash

echo "-------- Check for Updates ---------------"
echo "------------------------------------------"
#yum -y update

if [ ! -f /usr/bin/java ]; 
then
	echo "-------- PROVISIONING JAVA ---------------"
	echo "------------------------------------------"
  
	## Install Java
    yum -y install java-1.7.0-openjdk.x86_64

else
	echo "CHECK - Java already installed"
fi

if [ ! -f /etc/init.d/tomcat6 ]; 
then
	echo "-------- PROVISIONING TOMCAT ------------"
	echo "-----------------------------------------" 
	yum install -y install tomcat6 
	rmdir /var/lib/tomcat6/webapps
	ln -s /tomcat/webapps /var/lib/tomcat6/webapps
	service tomcat6 restart
else
	echo "CHECK - Tomcat already installed"
fi

if [ ! -f /tomcat/webapps/jenkins.war ]; 
then
	echo "-------- PROVISIONING JENKINS ------------"
	echo "------------------------------------------"
    curl -L http://mirrors.jenkins-ci.org/war/latest/jenkins.war -O /tomcat/webapps/jenkins.war
    service tomcat6 restart 
else
	echo "CHECK - Jenkins already installed"
fi

if [ ! -f /tomcat/webapps/gitblit.war ]; 
then
	echo "-------- PROVISIONING GITBLIT ---------------"
	echo "------------------------------------------"
    curl -L http://dl.bintray.com/gitblit/releases/gitblit-1.6.2.war -o /tomcat/webapps/gitblit.war
    service tomcat6 restart
else
	echo "CHECK - GitBlit already installed"
fi
