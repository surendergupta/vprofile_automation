#!/bin/bash

# echo message installtion start
echo "Starting WEB01"

# Update the ubuntu server
sudo apt-get update && sudo apt-get upgrade -y

# Install the nginx package
sudo apt-get install nginx -y

# Create Nginx conf file
cat <<EOF | sudo tee  /etc/nginx/sites-available/vproapp
upstream vproapp {
    server app01:8080;
}
server {
    listen 80;
    location / {
        proxy_pass http://vproapp;
    }
}
EOF

# Remove default nginx conf
sudo rm -rf /etc/nginx/sites-enabled/default

# Create link to activate website
sudo ln -s /etc/nginx/sites-available/vproapp /etc/nginx/sites-enabled/vproapp

# restart nginx server  
sudo systemctl start nginx
sudo systemctl enable nginx
sudo systemctl restart nginx