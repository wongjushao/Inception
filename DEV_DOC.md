# Developer Documentation

## 1) Environment setup from scratch

### Prerequisites

- Linux system
- Docker Engine
- Docker Compose plugin (`docker compose`)
- GNU Make
- Sudo rights (needed by Makefile directory ownership commands)

### Project configuration files

- Orchestration: `srcs/docker-compose.yml`
- Global variables and credentials: `srcs/.env`
- Service images:
  - `srcs/requirememnts/mariadb/Dockerfile`
  - `srcs/requirememnts/wordpress/Dockerfile`
  - `srcs/requirememnts/nginx/Dockerfile`
- Service startup scripts:
  - `srcs/requirememnts/mariadb/tools/init-db.sh`
  - `srcs/requirememnts/wordpress/tools/setup-wordpress.sh`
  - `srcs/requirememnts/nginx/tools/generate-ssl.sh`

### Secrets and credentials

Credentials are currently passed by environment file (`srcs/.env`) and injected via `env_file` in Compose.

At minimum, verify before first run:

- `DOMAIN_NAME`
- `MYSQL_DATABASE`, `MYSQL_USER`, `MYSQL_PASSWORD`, `MYSQL_ROOT_PASSWORD`
- `WP_ADMIN_*` and `WP_USER_*`
- `DATA_PATH`

### Hostname setup

Add your domain to `/etc/hosts`:

```bash
127.0.0.1 wjun-kea.42.fr
```

## 2) Build and launch with Makefile and Docker Compose

Run from repository root:

```bash
make            # default target: up
```

Main Makefile targets:

```bash
make build          # docker compose build
make build-nocache  # clean image rebuild
make up             # create runtime dirs and start stack
make down           # stop/remove containers
make clean          # down + remove volumes
make fclean         # clean + remove images and host data dirs
make re             # full reset and rebuild
make status         # docker compose ps
make logs           # docker compose logs -f
```

Equivalent direct Compose usage:

```bash
docker compose -f srcs/docker-compose.yml build
docker compose -f srcs/docker-compose.yml up -d
docker compose -f srcs/docker-compose.yml down
```

## 3) Manage containers and volumes

Inspect runtime state:

```bash
docker compose -f srcs/docker-compose.yml ps
docker compose -f srcs/docker-compose.yml logs -f
docker volume ls
```

Project volumes defined in Compose:

- `db-data`
- `wp-data`
- `ssl-data`

Remove project containers and volumes:

```bash
make clean
```

Full cleanup including images and persisted host data:

```bash
make fclean
```

## 4) Data storage and persistence model

This project persists state through named Docker volumes that are bind-backed to host paths.

Mapped persistence locations:

- MariaDB data: `${DATA_PATH}/mysql` (via volume `db-data`)
- WordPress files: `${DATA_PATH}/wordpress` (via volume `wp-data`)
- TLS cert/key: `../secrets/ssl` from compose directory (via volume `ssl-data`)

Why data survives restarts:

- Containers are ephemeral.
- Persistent directories are outside container writable layers.
- Recreating containers does not remove bind-backed volume data unless explicit cleanup (`make clean` / `make fclean`) is performed.
