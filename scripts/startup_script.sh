#!/bin/bash

# Get the instance's region from metadata server
REGION=$(curl -s http://metadata.google.internal/computeMetadata/v1/instance/zone -H "Metadata-Flavor: Google")

# Extract the short region name (e.g., "us-central1-a" -> "us-central1")
SHORT_REGION=$(echo "$REGION" | awk -F'/' '{print $4}' | cut -d'-' -f1,2)

sudo apt-get update
sudo apt-get install -y apache2
sudo a2enmod rewrite

# Use us-central1 instance for image_bullet.jpg
if [[ "$SHORT_REGION" == "us-central1" ]]; then
  # Use gsutil to copy the image
  gsutil cp gs://gcp-simple-global-web-app-demo-${project_id}/image_bullet.jpg /var/www/html/
fi

# Use europe-west1 instance for image_dome.jpg
if [[ "$SHORT_REGION" == "europe-west1" ]]; then
  # Use gsutil to copy the image
  gsutil cp gs://gcp-simple-global-web-app-demo-${project_id}/image_dome.jpg /var/www/html/
fi

# Use asia-southeast1 instance for image_asia.jpg
if [[ "$SHORT_REGION" == "asia-southeast1" ]]; then
  # Use gsutil to copy the image
  gsutil cp gs://gcp-simple-global-web-app-demo-${project_id}/image_asia.jpg /var/www/html/
fi

cat << EOF > /etc/apache2/sites-available/000-default.conf
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
EOF

sudo chown www-data:www-data /var/www/html # set www-data as owner of the directory

# Create the index.html file with dynamic content and image URL for USA

echo "<h1>Hello from $(hostname) in $SHORT_REGION</h1><img src='/image_bullet.jpg'>" > /var/www/html/index.html

# Change the Europe instances to use image_dome.jpg
if [[ "$SHORT_REGION" == "europe-west1" ]]; then
  echo "<h1>Hello from $(hostname) in $SHORT_REGION</h1><img src='/image_dome.jpg'>" > /var/www/html/index.html
fi

# Change the Asia instances to use image_asia.jpg
if [[ "$SHORT_REGION" == "asia-southeast1" ]]; then
  echo "<h1>Hello from $(hostname) in $SHORT_REGION</h1><img src='/image_asia.jpg'>" > /var/www/html/index.html
fi

sudo systemctl restart apache2
