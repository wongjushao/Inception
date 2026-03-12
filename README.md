*This project has been created as part of the 42 curriculum by wjun-kea.*

# Inception

## Description

Inception is a system administration project focused on building and orchestrating a small production-like web stack with Docker. The goal is to deploy a secure and modular WordPress website using multiple containers, each with a single responsibility, and to manage the full lifecycle with reproducible automation.

This repository builds and runs three services:
- **NGINX** (TLS termination on port 443)
- **WordPress + PHP-FPM** (application layer)
- **MariaDB** (database layer)

### Project Description, Docker Usage, and Included Sources

The stack is orchestrated with Docker Compose (`srcs/docker-compose.yml`) and custom Docker images for each service:
- `srcs/requirememnts/nginx/`
- `srcs/requirememnts/wordpress/`
- `srcs/requirememnts/mariadb/`

Key included sources and responsibilities:
- `Dockerfile` files define isolated runtime environments per service.
- Startup scripts in `tools/` (`generate-ssl.sh`, `setup-wordpress.sh`, `init-db.sh`) bootstrap runtime configuration and initialization.
- Service configuration files (`nginx.conf`, `mariadb.cnf`) define network exposure, reverse-proxy behavior, TLS parameters, and database settings.
- Volumes persist database and WordPress files under `${DATA_PATH}`.

Main design choices:
- **Separation of concerns**: one process family per container.
- **Custom images**: no monolithic prebuilt stack; each image is intentionally configured.
- **TLS-first entrypoint**: public traffic enters only through NGINX on `443`.
- **Persistent state**: data survives container recreation via bind-backed Docker volumes.

### Mandatory Technical Comparisons

#### Virtual Machines vs Docker
- **Virtual Machines** virtualize full guest operating systems and are heavier in CPU/RAM/storage.
- **Docker containers** virtualize at the OS level, share the host kernel, start faster, and are better suited for this lightweight multi-service setup.
- For Inception, Docker improves reproducibility and speed while keeping service isolation strong enough for the project scope.

#### Secrets vs Environment Variables
- **Environment variables** are simple and practical for non-sensitive config and local development.
- **Secrets** are better for sensitive values because they reduce accidental exposure (for example in process listings or logs).
- In this project, variables are currently passed through `.env`; in a stricter production model, database/admin credentials should be migrated to Docker secrets or an external secret manager.

#### Docker Network vs Host Network
- **Docker bridge network** isolates services and provides internal DNS (`mariadb`, `wordpress`, `nginx`) with controlled exposure.
- **Host network** removes network isolation and maps container services directly onto host networking.
- This project uses a dedicated bridge network (`inception`) to keep internal traffic private and expose only HTTPS.

#### Docker Volumes vs Bind Mounts
- **Docker-managed volumes** are portable and lifecycle-aware, managed by Docker.
- **Bind mounts** map specific host paths and are convenient when exact host persistence paths are needed.
- This repository defines named volumes (`db-data`, `wp-data`, `ssl-data`) backed by host paths via `driver_opts` (`type: none`, `o: bind`) to combine named-volume management with explicit host storage locations.

## Instructions

### Prerequisites
- Linux host with Docker Engine and Docker Compose plugin installed.
- `make` installed.
- Permission to run Docker commands.

### 1) Configure hostname (once)
Add your domain to `/etc/hosts`:

```bash
127.0.0.1 wjun-kea.42.fr
```

### 2) Review environment values
Edit `srcs/.env` as needed:
- Domain (`DOMAIN_NAME`)
- Credentials (`MYSQL_*`, `WP_*`)
- Data directory (`DATA_PATH`)

### 3) Build and run

From the repository root:

```bash
make
```

Useful commands:

```bash
make build          # Build images
make up             # Create dirs, start services
make logs           # Follow logs
make status         # Show container state
make down           # Stop and remove containers
make clean          # down + remove volumes
make fclean         # clean + remove images + data directories
make re             # Full rebuild from scratch
```

### 4) Access the website
- Open: `https://wjun-kea.42.fr`
- WordPress admin URL: `https://wjun-kea.42.fr/wp-admin`

## Resources

Classic references:
- Docker documentation: https://docs.docker.com/
- Docker Compose specification: https://docs.docker.com/compose/compose-file/
- NGINX documentation: https://nginx.org/en/docs/
- MariaDB documentation: https://mariadb.com/kb/en/documentation/
- WordPress documentation: https://wordpress.org/documentation/
- WP-CLI documentation: https://developer.wordpress.org/cli/commands/
- OpenSSL documentation: https://www.openssl.org/docs/

### AI Usage Disclosure

AI tools were used as an assistant during this project for:
- Drafting and refining technical explanations in documentation.
- Reviewing shell script clarity and checking command intent.
- Validating README structure against assignment requirements.
