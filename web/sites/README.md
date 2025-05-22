# Drupal Docker Setup: For Existing Drupal Projects

This guide explains how to run your existing Drupal 10/11 project using Docker Compose with:

- **MariaDB** (database)
- **PHP** (custom build)
- **Nginx** (web server)
- **Ubuntu helper container** for debugging and tools (optional)

---

## 1. System Requirements

- Docker Engine installed  
  _Check:_ `docker --version`
- Docker Compose installed  
  _Check:_ `docker-compose --version`

---

## 2. Expected Project Structure

The existing Drupal project should have the following structure (or be adjusted to fit):

```bash
my_drupal_ubuntu/
├── docker-compose.yml         # Docker Compose file
├── nginx.conf                 # Nginx configuration
├── php.ini                    # (Optional) PHP settings override
├── web/                       # Your existing Drupal site's document root
│   ├── index.php
│   ├── core/
│   ├── sites/
│   └── ...
├── vendor/                    # Composer dependencies
├── composer.json              # Existing Drupal project’s composer file
├── php-ubuntu/                # PHP Docker build context
│   └── Dockerfile
```

> **Note:** If your Drupal site uses `/docroot` instead of `/web`, update `docker-compose.yml` and `nginx.conf` accordingly.

---

## 3. Files & Configs

- `docker-compose.yml`
- `nginx.conf`
- `php-ubuntu/Dockerfile`
- `php.ini` (optional, to override PHP settings like memory limits or file upload size)

---

## 4. Setup Instructions (for Existing Drupal Project)

### 1. Prep your project

Copy your existing Drupal site into the `web/` folder:

```bash
my_drupal_ubuntu/
├── web/
│   ├── index.php
│   ├── core/
│   ├── modules/
│   └── ...
├── composer.json
```

---

### 2. Check `vendor/` exists

If not, run:

```bash
composer install
```

---

### 3. Set database credentials

Check `web/sites/default/settings.php` (or your local settings file) and ensure your database settings match:

```php
'database' => [
    'default' => [
        'default' => [
            'database' => 'drupal10',
            'username' => 'drupal10',
            'password' => 'drupal10',
            'host' => 'my_drupal_ubuntu_db',
            'port' => '3306',
            'driver' => 'mysql',
            'prefix' => '',
        ],
    ],
],
```

---

### 4. Build and run containers

In the project root, run:

```bash
docker-compose up --build -d
```

---

### 5. Check container status

```bash
docker-compose ps
```

---

### 6. Test the site in your browser

- **Local machine:** http://localhost:8088
- **Azure Dev Box:** Replace `localhost` with your Dev Box IP address.

---

## 5. Import a database

To import your database:

```bash
docker exec -i my_drupal_ubuntu_db mysql -u drupal10 -pdrupal10 drupal10 < your_database.sql
```

---

## 6. Useful Docker Commands

Check logs:

```bash
docker-compose logs nginx
docker-compose logs php
docker-compose logs db
```

Enter the PHP container:

```bash
docker exec -it my_drupal_ubuntu_php bash
```

Stop all containers:

```bash
docker-compose down
```

Rebuild & restart:

```bash
docker-compose down
docker-compose up --build -d
```

---

## 7. Using the Ubuntu Helper Container

To debug or run Linux tools inside the helper container:

```bash
docker exec -it my_drupal_ubuntu_shell bash
apt update && apt install vim
cd /var/www/web
```

---

## What to Look Out for in an Existing Project

- Ensure your existing site's folder (`web/`, `docroot/`, etc.) matches the paths in `nginx.conf` and `docker-compose.yml`.
- Verify that `vendor/` exists.
- Make sure the DB credentials (user/password/database name) in `settings.php` (or local settings file) match those in Docker Compose.

---

## Drush Commands

- Check status: `./vendor/bin/drush status`
- One-time login: `./vendor/bin/drush uli`
- Clear cache: `./vendor/bin/drush cr`