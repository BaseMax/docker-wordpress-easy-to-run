# 🐳 docker-wordpress-easy-to-run

A production-ready Docker setup for running WordPress with support for **ionCube** and **SourceGuardian** loaders.  
Built on top of the official [`wordpress`](https://hub.docker.com/_/wordpress) image.

---

## 🚀 Features

- ✅ WordPress with PHP 8.1
- ✅ Auto-install of [ionCube](https://basemax.github.io/ioncube-loaders-linux-x86-64/data.json) & [SourceGuardian](https://basemax.github.io/sourceguardian-loader-linux-x86-64/data.json) loaders via GitHub-hosted JSON
- ✅ MariaDB for local development
- ✅ Clean and minimal
- ✅ Simple multi-site setup using shared template and per-site env configs

![Docker Wordpress](wp.jpg)

---

## 📂 Folder Structure

```
docker-wordpress-easy-to-run/
├── template/                  # Shared Dockerfile, docker-compose.yml, and setup scripts
│   ├── Dockerfile
│   ├── docker-compose.yml
│   ├── setup-loaders.php
│   ├── setup-php.ini
│   └── setup-wp-content.sh
├── sites/                     # Multiple WordPress sites, each with own data & config
│   ├── site1/
│   │   ├── data/              # Database volume data for site1
│   │   ├── root/              # WordPress root files overrides for site1 (optional)
│   │   ├── wp-content/        # Themes, plugins, uploads for site1
│   │   └── .env               # Environment variables for site1
│   └── site2/
│       ├── data/
│       ├── root/
│       ├── wp-content/
│       └── .env
├── update.bat                 # Batch script to update all sites
├── update.sh                  # Bash script to update all sites
├── LICENSE
├── README.md
└── wp.jpg                    # Screenshot/example image
````

---

## ⚙️ Example `.env` file (per site)

```env
PROJECT_NAME=site1
WP_PORT=9876
PMA_PORT=9877

DATABASE_NAME=wordpress
DATABASE_USER=wordpress
DATABASE_PASSWORD=wordpress
DATABASE_ROOT_PASSWORD=root

PHP_VERSION=8.1
````

---

## ▶️ How to Run Multiple Sites

Run each site from the main folder using:

```bash
docker compose -p site1 --env-file sites/site1/.env -f template/docker-compose.yml up -d --build
docker compose -p site2 --env-file sites/site2/.env -f template/docker-compose.yml up -d --build
```

You can also use the provided scripts `update.bat` (Windows) or `update.sh` (Linux/macOS) to automatically build and start all sites under `sites/`.

---

## How to Manage One Site at a Time

Your project structure uses this pattern:

```bash
docker compose -p <project_name> --env-file sites/<project_name>/.env -f template/docker-compose.yml <command>
```

---

### 1. View Logs for One Site

```bash
docker compose -p site1 --env-file sites/site1/.env -f template/docker-compose.yml logs -f
```

This shows live logs (tail -f) for all containers in the `site1` project.

If you want to see logs for a specific container (e.g., the WordPress app container):

```bash
docker compose -p site1 --env-file sites/site1/.env -f template/docker-compose.yml logs -f site1-app
```

---

### 2. Stop One Site Completely

```bash
docker compose -p site1 --env-file sites/site1/.env -f template/docker-compose.yml down
```

This stops and removes containers, networks, but **does NOT remove volumes** (your database data remains).

If you want to remove volumes (to fully clean database and cache):

```bash
docker compose -p site1 --env-file sites/site1/.env -f template/docker-compose.yml down -v
```

---

### 3. Fully Delete One Site’s Data and Cache

You need to delete the `sites/site1/data/` directory manually (or using your OS file manager), as that is where your MariaDB database files persist.

Example for Windows (PowerShell):

```powershell
Remove-Item -Recurse -Force .\sites\site1\data\
```

On Linux/macOS terminal:

```bash
rm -rf sites/site1/data/
```

Then run:

```bash
docker compose -p site1 --env-file sites/site1/.env -f template/docker-compose.yml down -v
```

This ensures containers and volumes are removed, and the manual data folder deletion clears DB files.

---

### 4. Run One Site (Start or Restart)

```bash
docker compose -p site1 --env-file sites/site1/.env -f template/docker-compose.yml up -d --build
```

---

## 📋 Managing Individual Sites

### View logs for a site

```bash
docker compose -p site1 --env-file sites/site1/.env -f template/docker-compose.yml logs -f
````

### Stop and remove containers (keep database data)

```bash
docker compose -p site1 --env-file sites/site1/.env -f template/docker-compose.yml down
```

### Stop and remove containers and volumes (deletes database and cache)

```bash
docker compose -p site1 --env-file sites/site1/.env -f template/docker-compose.yml down -v
```

Also, manually delete the `sites/site1/data/` folder to fully remove database files.

### Start or rebuild a site

```bash
docker compose -p site1 --env-file sites/site1/.env -f template/docker-compose.yml up -d --build
```

---

### Note on your Errors:

- `docker compose logs` needs to be run **where your docker-compose.yml file is located or you must pass `-f <file>` correctly.**

- The `-p` (project name) flag must be **before** the command and **before** `-f`. Correct syntax:

```bash
docker compose -p site1 --env-file sites/site1/.env -f template/docker-compose.yml logs -f
````

(not after `logs -f`)

---

## 🧠 Tips

* Use `sites/siteX/wp-content/` to mount themes, plugins, and uploads per site
* Use `sites/siteX/root/` to mount root of WordPres
* Store database files under `sites/siteX/data/` to persist DB data per site
* Modify `.env` in each site folder to configure ports, DB credentials, and PHP version
* Always back up your `data/` folders to avoid losing database content

---

## 📄 License

MIT License

Copyright 2025, Seyyed Ali Mohammadiyeh (Max Base)
