#!/bin/bash

# Ensure mysql user owns the data directory
chown -R mysql:mysql /var/lib/mysql
chmod -R 755 /var/lib/mysql

# Initialize MySQL data directory if it doesn't exist
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB data directory..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# Start MySQL temporarily to configure
mysqld --user=mysql --bootstrap << EOF
USE mysql;
FLUSH PRIVILEGES;

-- Create database
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;

-- Create user and grant privileges
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';

-- Set root password
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';

FLUSH PRIVILEGES;
EOF

echo "MariaDB initialization complete."

# Start MariaDB in the foreground
exec mysqld --user=mysql --console
