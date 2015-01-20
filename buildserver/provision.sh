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
	mkdir /tomcat/webapps
    chown tomcat:tomcat /tomcat/webapps
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
    wget -O /tomcat/webapps/jenkins.war http://mirrors.jenkins-ci.org/war/latest/jenkins.war
    service tomcat6 restart 
else
	echo "CHECK - Jenkins already installed"
fi

if [ ! -f /tomcat/webapps/gitblit.war ]; 
then
	echo "-------- PROVISIONING GITBLIT ---------------"
	echo "------------------------------------------"
    wget  -O /tomcat/webapps/gitblit.war http://dl.bintray.com/gitblit/releases/gitblit-1.6.2.war
    service tomcat6 restart
else
	echo "CHECK - GitBlit already installed"
fi