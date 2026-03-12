#!/bin/bash

# Generate nginx.conf from template with environment variable substitution
envsubst '${DOMAIN_NAME}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

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
