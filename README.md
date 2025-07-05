# 🐳 docker-wordpress-easy-to-run

A production-ready Docker setup for running WordPress with support for **ionCube** and **SourceGuardian** loaders.
Built on top of the official [`wordpress:php8.1-fpm-alpine`](https://hub.docker.com/_/wordpress) image.

---

## 🚀 Features

- ✅ WordPress with PHP 8.1 (FPM + Alpine)
- ✅ Auto-install of ionCube & SourceGuardian via [GitHub-hosted JSON](https://basemax.github.io/)
- ✅ MariaDB for local development
- ✅ Clean and minimal — no `curl` or `jq` required
- ✅ Simple and easy to run

---

## 📦 Folder Structure

```
my-wordpress/
├── Dockerfile               # Custom PHP + loader integration
├── docker-compose.yml       # Docker multi-service setup
├── wp-content/              # Optional: your plugins/themes
└── .env                     # Optional environment values
````

---

## ▶️ Getting Started

1. Clone this repository:

   ```bash
   git clone https://github.com/YOUR_USERNAME/docker-wordpress-easy-to-run.git
   cd docker-wordpress-easy-to-run
````

2. Run WordPress:

   ```bash
   docker compose up --build -d
   ```

3. Visit your local site:

   ```
   http://localhost:8080
   ```

---

## 🔧 Docker Commands (Cheat Sheet)

### 🛠 Build & Start

```bash
docker compose up --build -d       # Build and run in background
docker compose up                  # Run and view logs (foreground)
```

### 💬 Logs

```bash
docker compose logs -f             # Tail all logs
docker compose logs wordpress      # View logs from wordpress container
docker compose logs db             # View logs from the database
```

### 🔄 Restart / Rebuild

```bash
docker compose restart             # Restart all services
docker compose restart wordpress   # Restart just WordPress
docker compose build --no-cache    # Force rebuild all services
```

### 🧼 Stop / Remove

```bash
docker compose stop                # Stop all containers
docker compose down                # Stop + remove all containers
docker compose down -v             # Also remove volumes (clean DB!)
```

### 🧹 Clean Everything

```bash
docker system prune -a             # WARNING: Removes all unused images/volumes/networks
docker volume prune                # Remove dangling volumes
docker container prune             # Remove stopped containers
docker image prune                 # Remove unused images
```

---

## 🧠 Tips

* 🗂 Use `./wp-content/` to mount your own themes/plugins
* 🔐 Change the DB passwords in `docker-compose.yml` before production
* ⚠️ Don’t forget to back up `volumes` if you store real data

---

## 📄 License

MIT License

Copyright 2025, Seyyed Ali Mohammadiyeh (Max Base)
