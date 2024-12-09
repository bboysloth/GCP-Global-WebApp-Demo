#!/bin/bash
sudo apt-get update
sudo apt-get install apache2 -y
sudo a2enmod rewrite

# Use a here-document to create the Apache configuration file
cat <<EOT > /etc/apache2/sites-available/000-default.conf
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html

    <Directory /var/www/html/>
        RewriteEngine On
        RewriteCond %{REQUEST_URI} !^/index\.html$
        RewriteRule ^(.*)$ /index.html [L]
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOT

sudo systemctl restart apache2

# Construct the image URL using the project_id variable
IMAGE_URL="https://storage.googleapis.com/gcp-simple-global-web-app-demo-us-${project_id}/image_bullet.jpg"

# Create the index.html file with the image URL
echo "<h1>Hello from $(hostname) in $(curl -s http://metadata.google.internal/computeMetadata/v1/instance/zone -H 'Metadata-Flavor: Google')</h1><img src='${IMAGE_URL}'>" > /var/www/html/index.html
