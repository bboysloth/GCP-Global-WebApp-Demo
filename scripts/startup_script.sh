#!/bin/bash

# Get the instance's region from metadata server
REGION=$(curl -s http://metadata.google.internal/computeMetadata/v1/instance/region -H "Metadata-Flavor: Google")

# Extract the short region name (e.g., "us-central1" -> "us")
SHORT_REGION=$(echo "$REGION" | awk -F'/' '{print $4}' | cut -d'-' -f1,2 | tr '-' '_')

sudo apt-get update
sudo apt-get install apache2 -y
sudo a2enmod rewrite

cat <<EOT > /etc/apache2/sites-available/000-default.conf
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html

    <Directory /var/www/html/>

        RewriteEngine On

        RewriteCond %%{REQUEST_URI} !^/index\.html$
        RewriteRule ^(.*)$ /index.html [L]
    </Directory>

    ErrorLog $${APACHE_LOG_DIR}/error.log
    CustomLog $${APACHE_LOG_DIR}/access.log combined

</VirtualHost>
EOT

# Construct the image URL based on the region
if [[ "$SHORT_REGION" == "us_central1" ]]; then

    IMAGE="image_bullet.jpg"
elif [[ "$SHORT_REGION" == "europe_west1" ]]; then

  IMAGE="image_dome.jpg"
elif [[ "$SHORT_REGION" == "asia_southeast1" ]]; then
    IMAGE="image_asia.jpg"
else

  echo "Unknown region: $SHORT_REGION"
  exit 1
fi

IMAGE_URL="https://storage.googleapis.com/gcp-simple-global-web-app-demo-${project_id}/$IMAGE"

# Create the index.html file with dynamic content and image URL

echo "<h1>Hello from $(hostname) in $SHORT_REGION</h1><img src='$IMAGE_URL'>" > /var/www/html/index.html

sudo systemctl restart apache2
