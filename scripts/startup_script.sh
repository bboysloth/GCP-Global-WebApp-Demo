#!/bin/bash

# Metadata server URLs
METADATA_SERVER="http://metadata.google.internal/computeMetadata/v1/instance/"
METADATA_HEADERS="Metadata-Flavor: Google"

# Get instance name
INSTANCE_NAME=$(curl -s -H "$METADATA_HEADERS" "${METADATA_SERVER}hostname")
# Get region
REGION=$(curl -s -H "$METADATA_HEADERS" "${METADATA_SERVER}region")
# Get zone
ZONE=$(curl -s -H "$METADATA_HEADERS" "${METADATA_SERVER}zone")

# Extract short region name
SHORT_REGION=$(echo "$REGION" | awk -F '/' '{print $4}')

# Determine image based on region
case "$SHORT_REGION" in
  "us-central1")
    IMAGE="image_bullet.jpg"
    ;;
  "europe-west1")
    IMAGE="image_dome.jpg"
    ;;

  "asia-southeast1")
    IMAGE="image_asia.jpg"
    ;;
  *)
    IMAGE="default_image.jpg"  # Default image if region is not recognized
    ;;

esac

# Construct the image URL
IMAGE_URL="https://storage.googleapis.com/gcp-simple-global-web-app-demo-${project_id}/${IMAGE}"

# Create index.html (escaped double quotes for variables within the echo command)
cat << EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
  <title>Welcome</title>
</head>
<body>

  <h1>Welcome to $INSTANCE_NAME in $ZONE</h1>
  <img src="$IMAGE_URL" alt="Regional Image">

</body>
</html>
EOF




# Install apache and start service
sudo apt-get update
sudo apt-get install -y apache2
sudo systemctl start apache2
