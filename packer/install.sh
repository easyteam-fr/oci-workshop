#!/bin/bash

set -e

yum-config-manager --disable ksplice-uptrack
yum-config-manager --disable ol7_ksplice
yum -y update
yum -y install httpd python2-pip
systemctl enable httpd
pip install oci-cli

mkdir -p /var/www/html
echo "<html>" >"/var/www/html/index.html"
echo "   <head><title>Live for the Code</title></head>" \
  >>"/var/www/html/index.html"
echo "   <body><h1>Live for the Code</h1></body>" \
  >>"/var/www/html/index.html"
echo "</html>" >>"/var/www/html/index.html"

# chown apache:apache "/var/www/html/index.html"
chmod a+r "/var/www/html/index.html"

firewall-cmd --permanent --zone=public --add-port=80/tcp

