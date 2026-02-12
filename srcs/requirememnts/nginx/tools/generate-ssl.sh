#!/bin/bash

# Replace DOMAIN_NAME in nginx.conf with actual domain from environment
sed -i "s/DOMAIN_NAME/${DOMAIN_NAME}/g" /etc/nginx/nginx.conf

# Generate self-signed SSL certificate if it doesn't exist
if [ ! -f "/etc/nginx/ssl/nginx.crt" ]; then
    echo "Generating self-signed SSL certificate..."
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/nginx.key \
        -out /etc/nginx/ssl/nginx.crt \
        -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=${DOMAIN_NAME}"
    echo "SSL certificate generated!"
fi

# Start NGINX in the foreground
echo "Starting NGINX..."
exec nginx -g "daemon off;"
