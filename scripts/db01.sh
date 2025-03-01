#!/bin/bash

DATABASE_PASS='admin123'

# echo message installtion start
echo "Starting DB01"

# Update the centos9 server
sudo yum update -y

# Install the epel-release, git, mariadb-server package
sudo yum install epel-release git mariadb-server -y

# start mariadb service
sudo systemctl start mariadb
# enable mariadb service
sudo systemctl enable mariadb

# Going to tmp directory
cd /tmp/

# clone the git project inside tmp directory using local branch
git clone -b local https://github.com/hkhcoder/vprofile-project.git

# run mysql_secure_installation script
sudo mysqladmin -u root password "$DATABASE_PASS"
sudo mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1')"
sudo mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.user WHERE User=''"
sudo mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%'"
sudo mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES"
sudo mysql -u root -p"$DATABASE_PASS" -e "create database accounts"
sudo mysql -u root -p"$DATABASE_PASS" -e "grant all privileges on accounts.* TO 'admin'@'localhost' identified by 'admin123'"
sudo mysql -u root -p"$DATABASE_PASS" -e "grant all privileges on accounts.* TO 'admin'@'%' identified by 'admin123'"
sudo mysql -u root -p"$DATABASE_PASS" accounts < /tmp/vprofile-project/src/main/resources/db_backup.sql
sudo mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES"

# restart mariadb
sudo systemctl restart mariadb

# start firewalld service and allow port 3306 default port of mysql
sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo firewall-cmd --get-active-zones
sudo firewall-cmd --zone=public --add-port=3306/tcp --permanent
sudo firewall-cmd --reload

# restart mariadb
sudo systemctl restart mariadb

# echo message installtion complete
echo "DB01 bash scriptcompleted"