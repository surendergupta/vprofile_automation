#!/bin/bash

# echo message installtion start
echo "Starting MC01"

# Update the centos9 server
sudo yum update -y

# Install the epel-release, memcached package 
sudo yum install epel-release  memcached -y

# start memcached service
sudo systemctl start memcached

# enable memcached service
sudo systemctl enable memcached

# check status of memcached service
sudo systemctl status memcached

# allow instead of localhost ip address to global ip address
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/sysconfig/memcached

# restart memcached service
sudo systemctl restart memcached

# start firewalld service
sudo systemctl start firewalld

# enable firewalld service
sudo systemctl enable firewalld

# allow port 11211 and 11111
sudo firewall-cmd --add-port=11211/tcp
sudo firewall-cmd --runtime-to-permanent
sudo firewall-cmd --add-port=11111/udp
sudo firewall-cmd --runtime-to-permanent

# start memcached in background with specific port and username
sudo memcached -p 11211 -U 11111 -u memcached -d
