#!/bin/bash

# Update packages and install Apache
dnf update -y
dnf install -y httpd wget

# Enable and start Apache
systemctl enable --now httpd

