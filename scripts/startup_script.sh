#!/bin/bash

#!/bin/bash

# Get the instance's zone from the metadata server
ZONE=$(curl -s http://metadata.google.internal/computeMetadata/v1/instance/zone -H "Metadata-Flavor: Google")

# Extract the region name (e.g., "us-central1-a" -> "us-central1")
REGION=$(echo "$ZONE" | awk -F'/' '{print $4}' | cut -d'-' -f1,2)

# Extract the short region name (e.g., "us-central1" -> "us")
SHORT_REGION=$(echo "$REGION" | awk -F'/' '{print $4}' | cut -d'-' -f1,2 | tr '-' '_')

sudo apt-get update
sudo apt-get install -y apache2
sudo a2enmod rewrite

# Define the base URL for the images
IMAGE_BASE_URL="https://storage.googleapis.com/gcp-simple-global-web-app-demo-${project_id}"

# Use us-central1 instance for image_bullet.jpg
if [[ "$SHORT_REGION" == "us_central1" ]]; then
  # Use direct URL for the image
  IMAGE_URL="$IMAGE_BASE_URL/image_bullet.jpg"
fi

# Use europe-west1 instance for image_dome.jpg
if [[ "$SHORT_REGION" == "europe_west1" ]]; then
  # Use direct URL for the image
  IMAGE_URL="$IMAGE_BASE_URL/image_dome.jpg"
fi

# Use asia-southeast1 instance for image_asia.jpg
if [[ "$SHORT_REGION" == "asia_southeast1" ]]; then
  # Use direct URL for the image
  IMAGE_URL="$IMAGE_BASE_URL/image_asia.jpg"
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

# Create the index.html file with dynamic content and direct image URL
echo "<h1>Hello from $(hostname) in $SHORT_REGION</h1><img src='$IMAGE_URL'>" > /var/www/html/index.html

sudo systemctl restart apache2
