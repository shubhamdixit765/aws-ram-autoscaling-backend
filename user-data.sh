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

