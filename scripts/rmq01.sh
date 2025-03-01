#!/bin/bash

# echo message installtion start
echo "Starting RMQ01"

# Update the centos9 server
sudo yum update -y

# Install the epel-release, wget, centos-release-rabbitmq-38 package
sudo yum install wget epel-release centos-release-rabbitmq-38 -y
sudo yum --enablerepo=centos-rabbitmq-38 install rabbitmq-server -y

# enable rabbitmq service
systemctl enable --now rabbitmq-server

# create file rabbitmq.config and put content in it
sudo sh -c 'echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config'

# rabbitmqctl add user
sudo rabbitmqctl add_user test test

# rabbitmqctl add tags
sudo rabbitmqctl set_user_tags test administrator

# rabbitmqctl set permissions
sudo rabbitmqctl set_permissions -p / test ".*" ".*" ".*"

# restart rabbitmq server
sudo systemctl restart rabbitmq-server

# start firewalld service and allow port 5672
sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo firewall-cmd --add-port=5672/tcp
sudo firewall-cmd --runtime-to-permanent

# start, enable and status rabbitmq server
sudo systemctl start rabbitmq-server
sudo systemctl enable rabbitmq-server
sudo systemctl status rabbitmq-server

# echo message installtion end
echo "Ending RMQ01"