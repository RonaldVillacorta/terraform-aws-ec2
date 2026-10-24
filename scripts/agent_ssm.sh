#!/bin/bash

echo "Updating system packages..."
apt-get update -y 
apt-get upgrade -y

echo "Installing Nginx for ${web_app}..."
apt-get install -y nginx
systemctl enable nginx & systemctl start nginx

echo "Installing Amazon SSM Agent..."
snap install amazon-ssm-agent --classic
snap start amazon-ssm-agent