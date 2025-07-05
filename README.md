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

### Export SQL Database from a Site

Run this command to export the database from the site’s MariaDB container to a `.sql` file on your host machine:

```bash
docker exec -i ${PROJECT_NAME}-db mysqldump -u${DATABASE_USER} -p${DATABASE_PASSWORD} ${DATABASE_NAME} > ${PROJECT_NAME}_backup.sql
```

Example for `site1` (run from your main folder):

```bash
docker exec -i site1-db mysqldump -uwordpress -pwordpress wordpress > site1_backup.sql
```

This will create `site1_backup.sql` with a full SQL dump of the WordPress database.

---

### Open Bash Shell Inside WordPress or Database Container

Sometimes you want to enter the container shell for debugging or manual operations.

* Enter WordPress app container bash:

```bash
docker exec -it ${PROJECT_NAME}-app bash
```

Example for `site2`:

```bash
docker exec -it site2-app bash
```

* Enter MariaDB container shell (MySQL client):

```bash
docker exec -it ${PROJECT_NAME}-db bash
```

Then inside the container:

```bash
mysql -u${DATABASE_USER} -p${DATABASE_PASSWORD} ${DATABASE_NAME}
```

Example:

```bash
docker exec -it site1-db bash
mysql -uwordpress -pwordpress wordpress
```

---

### Import SQL Dump into Database

If you have an SQL dump file and want to restore it into the database container, use this:

```bash
docker exec -i ${PROJECT_NAME}-db mysql -u${DATABASE_USER} -p${DATABASE_PASSWORD} ${DATABASE_NAME} < /path/to/your_dump.sql
```

Example (assuming your SQL dump is `site1_backup.sql` in your current folder):

```bash
cat site1_backup.sql | docker exec -i site1-db mysql -uwordpress -pwordpress wordpress
```

This pipes the SQL file into the container's MySQL client and restores the database.

---

### Summary Command Examples for `site1`

```bash
# Export DB
docker exec -i site1-db mysqldump -uwordpress -pwordpress wordpress > site1_backup.sql

# Enter WordPress app container shell
docker exec -it site1-app bash

# Enter DB container shell & MySQL client
docker exec -it site1-db bash
mysql -uwordpress -pwordpress wordpress

# Import DB dump back to container
cat site1_backup.sql | docker exec -i site1-db mysql -uwordpress -pwordpress wordpress
```

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
