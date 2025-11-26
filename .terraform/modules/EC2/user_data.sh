#!/bin/bash
# Update system
yum update -y

# Install Apache, PHP 8.2, and required extensions
yum install -y httpd php php-mysqlnd php-fpm php-json php-gd php-mbstring php-xml php-zip wget

# Start and enable Apache
systemctl start httpd
systemctl enable httpd

# Download and install WordPress
cd /tmp
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
cp -r wordpress/* /var/www/html/

# Configure WordPress
cd /var/www/html
cp wp-config-sample.php wp-config.php

# Update database configuration
sed -i "s/database_name_here/${db_name}/" wp-config.php
sed -i "s/username_here/${db_username}/" wp-config.php
sed -i "s/password_here/${db_password}/" wp-config.php
sed -i "s/localhost/${db_endpoint}/" wp-config.php

# Generate unique salts
SALT=$(curl -s https://api.wordpress.org/secret-key/1.1/salt/)
STRING='put your unique phrase here'
printf '%s\n' "g/$STRING/d" a "$SALT" . w | ed -s wp-config.php

# Set proper permissions
chown -R apache:apache /var/www/html
chmod -R 755 /var/www/html

# Configure Apache
sed -i 's/AllowOverride None/AllowOverride All/g' /etc/httpd/conf/httpd.conf

# Restart Apache
systemctl restart httpd

# Create health check file
echo "OK" > /var/www/html/health.html
