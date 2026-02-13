# Inception

A Docker-based WordPress installation with NGINX, MariaDB, and WordPress running in separate containers.

## Prerequisites

- Docker and Docker Compose
- sudo access (for hosts file configuration)

## Setup

### 1. Configure Environment

Create your environment configuration file:

```bash
cp srcs/.env.example srcs/.env
```

Edit `srcs/.env` and update the following values:
- `DOMAIN_NAME`: Your domain (e.g., `your_login.42.fr`)
- `MYSQL_ROOT_PASSWORD`: Secure password for MySQL root user
- `MYSQL_PASSWORD`: Secure password for WordPress database user
- `WP_ADMIN_PASSWORD`: Secure password for WordPress admin
- `WP_USER_PASSWORD`: Secure password for WordPress editor
- `DATA_PATH`: Path where data will be stored (e.g., `/home/your_login/data`)

### 2. Configure Hosts File

For your browser to resolve your custom domain, you need to add it to `/etc/hosts`:

```bash
sudo sh -c 'echo "127.0.0.1    your_login.42.fr" >> /etc/hosts'
```

Replace `your_login.42.fr` with the domain you configured in `DOMAIN_NAME`.

**Why is this needed?**
Custom domains like `*.42.fr` don't exist in public DNS. Adding them to `/etc/hosts` tells your system to resolve them to localhost (127.0.0.1), allowing your browser to connect to the Docker containers.

### 3. Build and Start

Build and start all containers:

```bash
make
```

Or use individual commands:

```bash
make build    # Build Docker images
make up       # Start containers
make start    # Build and start (equivalent to: make build up)
```

The Makefile will automatically check if your hosts file is configured and display a warning if not.

## Usage

### Access Your Site

Once running, access your WordPress site at:
```
https://your_login.42.fr
```

**Note:** You'll see a security warning because we use self-signed SSL certificates. This is normal for local development. Click "Advanced" and "Accept the Risk and Continue" (or similar in your browser).

### Manage Containers

```bash
make status    # View container status
make logs      # View container logs
make restart   # Restart containers
make down      # Stop containers
make clean     # Stop and remove volumes
make fclean    # Stop, remove volumes and images
```

## Troubleshooting

### Browser shows "We can't connect to the server"

**Cause:** Your domain is not in `/etc/hosts`.

**Solution:** Add your domain to `/etc/hosts`:
```bash
sudo sh -c 'echo "127.0.0.1    your_login.42.fr" >> /etc/hosts'
```

### Port 443 already in use

**Cause:** Another service is using port 443.

**Solution:** Stop the conflicting service or change the port mapping in `srcs/docker-compose.yml`.

### Permission denied errors

**Cause:** Docker or data directories need proper permissions.

**Solution:** 
- Ensure your user is in the docker group: `sudo usermod -aG docker $USER`
- Ensure data directories are accessible: `chmod 755 ~/data`
- Log out and back in for group changes to take effect

## Architecture

The project consists of three main services:

- **NGINX**: Web server with SSL/TLS termination (port 443)
- **WordPress**: PHP-FPM running WordPress
- **MariaDB**: MySQL database server

All services run in separate Docker containers and communicate over a dedicated Docker network.
