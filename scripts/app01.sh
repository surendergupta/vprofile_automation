#!/bin/bash

# echo message installtion tomcat start
echo "Starting App01"

# Update the centos9 server
sudo yum update -y

# Install the epel-release, wget, java-17-openjdk, java-17-openjdk-devel, git, unzip package
sudo yum install epel-release wget java-17-openjdk java-17-openjdk-devel -y
sudo yum install git -y
sudo yum install unzip -y

# Going to tmp directory
cd /tmp/

# download tomcat package
wget https://archive.apache.org/dist/tomcat/tomcat-10/v10.1.26/bin/apache-tomcat-10.1.26.tar.gz

# Extract the tomcat package
tar xzvf apache-tomcat-10.1.26.tar.gz

# Add tomcat user at directory level
sudo useradd --home-dir /usr/local/tomcat --shell /sbin/nologin tomcat

# Copy data form totomcat directory to home directory
sudo cp -r /tmp/apache-tomcat-10.1.26/* /usr/local/tomcat/

# Make tomcat user owner of tomcat home directory
sudo chown -R tomcat:tomcat /usr/local/tomcat

# Create tomcat service file
cat <<EOF | sudo tee /etc/systemd/system/tomcat.service
[Unit]
Description=Tomcat
After=network.target

[Service]
User=tomcat
Group=tomcat
WorkingDirectory=/usr/local/tomcat
Environment=JAVA_HOME=/usr/lib/jvm/jre
Environment=CATALINA_PID=/var/tomcat/%i/run/tomcat.pid
Environment=CATALINA_HOME=/usr/local/tomcat
Environment=CATALINE_BASE=/usr/local/tomcat
ExecStart=/usr/local/tomcat/bin/catalina.sh run
ExecStop=/usr/local/tomcat/bin/shutdown.sh
RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd files
sudo systemctl daemon-reload

# start & enable tomcat service
sudo systemctl start tomcat
sudo systemctl enable tomcat

# Enabling the firewall and allowing port 8080 to access the tomcat
sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo firewall-cmd --zone=public --add-port=8080/tcp --permanent
sudo firewall-cmd --reload

# download maven package
wget https://archive.apache.org/dist/maven/maven-3/3.9.9/binaries/apache-maven-3.9.9-bin.zip

# Extract the maven package
unzip apache-maven-3.9.9-bin.zip

# copy extracted maven package to maven directory
sudo cp -r apache-maven-3.9.9 /usr/local/maven3.9

# export maven path to environment variable use max memory
export MAVEN_OPTS="-Xmx512m"

# clone the git project inside tmp directory using local branch
git clone -b local https://github.com/hkhcoder/vprofile-project.git

# change the directory to build the project
cd vprofile-project
/usr/local/maven3.9/bin/mvn install

# stop tomcat server
sudo systemctl stop tomcat

# wait 20 second
sleep 20

# remove tomcat webapps all file Start with ROOT
rm -rf /usr/local/tomcat/webapps/ROOT*

# copy new build package war file to tomcat webapps directory
if [ -f target/vprofile-v2.war ]; then
    cp target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war
else
    echo "Build failed: WAR file not found"
    exit 1
fi

# start tomcat server
sudo systemctl start tomcat

# wait 20 second
sleep 20

# change the owner of tomcat webapps directory to tomcat user
chown -R tomcat.tomcat /usr/local/tomcat/webapps

# restart tomcat server
sudo systemctl restart tomcat
