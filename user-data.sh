#!/bin/bash

# Update packages and install Apache
dnf update -y
dnf install -y httpd wget

# Enable and start Apache
systemctl enable --now httpd

# Configure Apache KeepAlive
cat >> /etc/httpd/conf/httpd.conf <<'EOF'

KeepAlive On
KeepAliveTimeout 65
MaxKeepAliveRequests 100
EOF

systemctl restart httpd

# Create application directories
mkdir -p /var/www/html/app1

# Create application pages
echo "<h1>Welcome to App 1</h1>" > /var/www/html/app1/index.html
echo "<h1>Welcome to Root App</h1>" > /var/www/html/index.html

# Download and install CloudWatch Agent
wget https://amazoncloudwatch-agent.s3.amazonaws.com/redhat/amd64/latest/amazon-cloudwatch-agent.rpm

rpm -U ./amazon-cloudwatch-agent.rpm

