# User Documentation

## What this stack provides

This project runs a secure WordPress website with three services:

- **NGINX**: receives HTTPS traffic on port `443` and serves as reverse proxy.
- **WordPress (PHP-FPM)**: provides the website and admin panel.
- **MariaDB**: stores WordPress content, users, and settings.

## Start and stop the project

From the repository root:

```bash
make
```

Useful lifecycle commands:

```bash
make up       # start services in background
make down     # stop and remove containers
make restart  # restart stack
make status   # show current container state
make logs     # follow logs
```

## Access the website and admin panel

1. Ensure your host resolves the domain in `/etc/hosts` (example):

```bash
127.0.0.1 wjun-kea.42.fr
```

2. Open the website:
- `https://wjun-kea.42.fr`

3. Open WordPress admin panel:
- `https://wjun-kea.42.fr/wp-admin`

## Locate and manage credentials

Credentials are stored in:

- `srcs/.env`

Important values include:

- MariaDB: `MYSQL_ROOT_PASSWORD`, `MYSQL_USER`, `MYSQL_PASSWORD`
- WordPress admin: `WP_ADMIN_USER`, `WP_ADMIN_PASSWORD`, `WP_ADMIN_EMAIL`
- Extra WordPress user: `WP_USER`, `WP_USER_PASSWORD`, `WP_USER_EMAIL`

After editing credentials, apply changes by rebuilding/restarting:

```bash
make re
```

## Check services are running correctly

Quick checks:

```bash
make status
make logs
```

Expected behavior:

- All containers (`nginx`, `wordpress`, `mariadb`) show as running.
- `https://wjun-kea.42.fr` loads without browser connection errors.
- Admin login works at `/wp-admin` with credentials from `srcs/.env`.

If a service is down:

1. Check logs (`make logs`).
2. Confirm `.env` values are correct.
3. Restart (`make restart`) or full rebuild (`make re`).
