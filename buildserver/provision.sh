#!/bin/bash

echo "-------- Check for Updates ---------------"
echo "------------------------------------------"
yum -y update

if [ ! -f /usr/bin/java ]; 
then
	echo "-------- PROVISIONING JAVA ---------------"
	echo "------------------------------------------"
  
	## Install Java
    yum -y install java-1.7.0-openjdk.x86_64

else
	echo "CHECK - Java already installed"
fi


if [ ! -f /etc/init.d/jenkins ]; 
then
	echo "-------- PROVISIONING JENKINS ------------"
	echo "------------------------------------------"
 
 
	## Install Jenkins
	#
	# URL: http://localhost:6060
	# Home: /var/lib/jenkins
	# Start/Stop: /etc/init.d/jenkins
	# Config: /etc/default/jenkins
	# Jenkins log: /var/log/jenkins/jenkins.log

    wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
    rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key
    yum -y install jenkins
 
	# Move Jenkins to port 6060
	sed -i 's/8080/6060/g' /etc/sysconfig/jenkins
    sed -i 's/JENKINS_ARGS=""/JENKINS_ARGS="--prefix=\/jenkins"/' /etc/sysconfig/jenkins
	wget -O /var/lib/jenkins/plugins/it-client.hpi https://updates.jenkins-ci.org/download/plugins/git-client/1.11.1/git-client.hpi
	wget -O /var/lib/jenkins/plugins/git.hpi https://updates.jenkins-ci.org/download/plugins/git/2.3/git.hpi
	service jenkins restart
else
	echo "CHECK - Jenkins already installed"
fi


# if [ ! -f /etc/init.d/tomcat6 ]; 
# then
# 	echo "-------- PROVISIONING TOMCAT ------------"
# 	echo "-----------------------------------------"
 
 
# 	## Install Tomcat (port 8080) 
# 	# This gives us something to deploy builds into
# 	# CATALINA_BASE=/var/lib/tomcat7
# 	# CATALINE_HOME=/usr/share/tomcat7
# 	#export JAVA_HOME="/usr/lib/jvm/java"
# 	yum install -y install tomcat6
 
# 	# Work around a bug in the default tomcat start script
# 	#sed -i 's/export JAVA_HOME/export JAVA_HOME=\"\/usr\/lib\/jvm\/java-7-oracle\"/g' /etc/init.d/tomcat7
# 	service tomcat6 restart
# else
# 	echo "CHECK - Tomcat already installed"
# fi
 

# if [ ! -f /var/lib/tomcat6/webapps/gitblit.war ]; 
# then
# 	echo "-------- PROVISIONING GITBLIT ---------------"
# 	echo "------------------------------------------"
  
# 	## Download GitBlit WAR
#     curl -L http://dl.bintray.com/gitblit/releases/gitblit-1.6.2.war -o /var/lib/tomcat6/webapps/gitblit.war
#     service tomcat6 restart
# else
# 	echo "CHECK - GitBlit already installed"
# fi

if [ ! -f /gitblit/gitblit-1.6.2.tar.gz ]; 
then
	echo "-------- PROVISIONING GITBLIT ---------------"
	echo "------------------------------------------"
      
	## Download GitBlit JAR
    curl -L http://dl.bintray.com/gitblit/releases/gitblit-1.6.2.tar.gz -o /gitblit/gitblit-1.6.2.tar.gz
    tar zxf /gitblit/gitblit-1.6.2.tar.gz 
    java -cp gitblit.jar com.gitblit.authority.Launcher --baseFolder data &
else
	echo "CHECK - GitBlit already installed"
fi
