#!/bin/bash
##install packages 
sudo yum install wget unzip httpd -y

mkdir -p /tmp/webfiles
cd /tmp/webfiles

sudo systemctl restart httpd
rm -rf /tmp/webfiles

sudo systemctl status httpd