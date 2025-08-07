# 🚀 VoltargeGo Sunucu Kurulum Rehberi

## 📋 Sunucu Gereksinimleri

### Minimum Gereksinimler

- **RAM**: 2GB (3GB önerilen)
- **CPU**: 2 Core
- **Disk**: 20GB
- **OS**: Ubuntu 20.04+ veya Debian 11+

## 🔧 Adım Adım Kurulum

### 1. Sunucu Güncellemesi

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install curl wget git unzip -y
```

### 2. PHP 8.1 Kurulumu

```bash
# PHP repository ekleme
sudo apt install software-properties-common -y
sudo add-apt-repository ppa:ondrej/php -y
sudo apt update

# PHP 8.1 ve gerekli extension'lar
sudo apt install php8.1 php8.1-fpm php8.1-mysql php8.1-xml php8.1-curl php8.1-mbstring php8.1-zip php8.1-bcmath php8.1-gd php8.1-redis php8.1-intl -y

# PHP konfigürasyonu
sudo sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 10M/' /etc/php/8.1/fpm/php.ini
sudo sed -i 's/post_max_size = 8M/post_max_size = 10M/' /etc/php/8.1/fpm/php.ini
sudo sed -i 's/memory_limit = 128M/memory_limit = 256M/' /etc/php/8.1/fpm/php.ini
```

### 3. Composer Kurulumu

```bash
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
sudo chmod +x /usr/local/bin/composer
```

### 4. MySQL Kurulumu

```bash
sudo apt install mysql-server -y
sudo mysql_secure_installation

# MySQL'e giriş
sudo mysql -u root -p

# Veritabanı ve kullanıcı oluşturma
CREATE DATABASE voltargego CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'voltargego_user'@'localhost' IDENTIFIED BY 'güçlü_şifre_buraya';
GRANT ALL PRIVILEGES ON voltargego.* TO 'voltargego_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

### 5. Nginx Kurulumu

```bash
sudo apt install nginx -y
sudo systemctl enable nginx
sudo systemctl start nginx
```

### 6. Laravel Projesi Kurulumu

```bash
# Web dizinine geç
cd /var/www

# Laravel projesi oluştur
sudo composer create-project laravel/laravel voltargego-api
sudo chown -R www-data:www-data voltargego-api
sudo chmod -R 755 voltargego-api
sudo chmod -R 775 voltargego-api/storage
sudo chmod -R 775 voltargego-api/bootstrap/cache
```

### 7. Laravel Konfigürasyonu

```bash
cd /var/www/voltargego-api

# Environment dosyası oluştur
sudo cp .env.example .env
sudo nano .env
```

### .env Dosyası İçeriği

```env
APP_NAME="VoltargeGo API"
APP_ENV=production
APP_KEY=base64:your-app-key-here
APP_DEBUG=false
APP_URL=https://your-server-ip-or-domain.com

LOG_CHANNEL=stack
LOG_DEPRECATIONS_CHANNEL=null
LOG_LEVEL=error

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=voltargego
DB_USERNAME=voltargego_user
DB_PASSWORD=güçlü_şifre_buraya

BROADCAST_DRIVER=log
CACHE_DRIVER=file
FILESYSTEM_DISK=local
QUEUE_CONNECTION=sync
SESSION_DRIVER=file
SESSION_LIFETIME=120

MEMCACHED_HOST=127.0.0.1

REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379

MAIL_MAILER=smtp
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD=your-app-password
MAIL_ENCRYPTION=tls
MAIL_FROM_ADDRESS=your-email@gmail.com
MAIL_FROM_NAME="${APP_NAME}"

AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_DEFAULT_REGION=us-east-1
AWS_BUCKET=
AWS_USE_PATH_STYLE_ENDPOINT=false

PUSHER_APP_ID=
PUSHER_APP_KEY=
PUSHER_APP_SECRET=
PUSHER_HOST=
PUSHER_PORT=443
PUSHER_SCHEME=https
PUSHER_APP_CLUSTER=mt1

VITE_APP_NAME="${APP_NAME}"
VITE_PUSHER_APP_KEY="${PUSHER_APP_KEY}"
VITE_PUSHER_HOST="${PUSHER_HOST}"
VITE_PUSHER_PORT="${PUSHER_PORT}"
VITE_PUSHER_SCHEME="${PUSHER_SCHEME}"
VITE_PUSHER_APP_CLUSTER="${PUSHER_APP_CLUSTER}"

# JWT Konfigürasyonu
JWT_SECRET=your-super-secret-jwt-key-here
JWT_TTL=10080
JWT_REFRESH_TTL=20160
```

### 8. Laravel Kurulum Komutları

```bash
cd /var/www/voltargego-api

# App key oluştur
sudo php artisan key:generate

# JWT secret oluştur
sudo php artisan jwt:secret

# Gerekli paketler
sudo composer require tymon/jwt-auth
sudo composer require intervention/image
sudo composer require spatie/laravel-permission
sudo composer require barryvdh/laravel-cors

# JWT konfigürasyonu
sudo php artisan vendor:publish --provider="Tymon\JWTAuth\Providers\LaravelServiceProvider"

# Migration'ları çalıştır
sudo php artisan migrate

# Storage link oluştur
sudo php artisan storage:link

# Cache'leri temizle
sudo php artisan config:clear
sudo php artisan cache:clear
sudo php artisan route:clear
sudo php artisan view:clear

# Production optimizasyonu
sudo php artisan config:cache
sudo php artisan route:cache
sudo php artisan view:cache
```

### 9. Nginx Konfigürasyonu

```bash
# Nginx site konfigürasyonu oluştur
sudo nano /etc/nginx/sites-available/voltargego
```

### Nginx Konfigürasyonu İçeriği

```nginx
server {
    listen 80;
    server_name your-server-ip-or-domain.com;
    root /var/www/voltargego-api/public;
    index index.php index.html index.htm;

    # Gzip sıkıştırma
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_proxied expired no-cache no-store private must-revalidate auth;
    gzip_types text/plain text/css text/xml text/javascript application/x-javascript application/xml+rss application/javascript;

    # API rate limiting
    limit_req_zone $binary_remote_addr zone=api:10m rate=10r/s;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
        include fastcgi_params;
        fastcgi_read_timeout 300;
    }

    # API rate limiting
    location /api/ {
        limit_req zone=api burst=20 nodelay;
        limit_req_status 429;
    }

    # Güvenlik
    location ~ /\.(?!well-known).* {
        deny all;
    }

    # Statik dosyalar
    location ~* \.(jpg|jpeg|png|gif|ico|css|js|pdf|txt)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # Upload limit
    client_max_body_size 10M;
}
```

### 10. Nginx Site'ı Aktifleştirme

```bash
# Site'ı aktifleştir
sudo ln -s /etc/nginx/sites-available/voltargego /etc/nginx/sites-enabled/

# Default site'ı kaldır
sudo rm /etc/nginx/sites-enabled/default

# Nginx konfigürasyonunu test et
sudo nginx -t

# Nginx'i yeniden başlat
sudo systemctl restart nginx
```

### 11. SSL Sertifikası (Let's Encrypt)

```bash
# Certbot kurulumu
sudo apt install certbot python3-certbot-nginx -y

# SSL sertifikası al
sudo certbot --nginx -d your-server-ip-or-domain.com

# Otomatik yenileme
sudo crontab -e
# Aşağıdaki satırı ekle:
0 12 * * * /usr/bin/certbot renew --quiet
```

### 12. Firewall Konfigürasyonu

```bash
# UFW kurulumu
sudo apt install ufw -y

# SSH erişimi
sudo ufw allow ssh

# HTTP ve HTTPS
sudo ufw allow 80
sudo ufw allow 443

# UFW'yi aktifleştir
sudo ufw enable
```

### 13. Monitoring ve Logging

```bash
# Logrotate konfigürasyonu
sudo nano /etc/logrotate.d/voltargego

# İçerik:
/var/www/voltargego-api/storage/logs/*.log {
    daily
    missingok
    rotate 52
    compress
    delaycompress
    notifempty
    create 644 www-data www-data
}
```

### 14. Backup Script

```bash
# Backup script oluştur
sudo nano /root/backup.sh
```

### Backup Script İçeriği

```bash
#!/bin/bash

BACKUP_DIR="/backup/voltargego"
DATE=$(date +%Y%m%d_%H%M%S)

# Backup dizini oluştur
mkdir -p $BACKUP_DIR

# Database backup
mysqldump -u voltargego_user -p voltargego > $BACKUP_DIR/db_backup_$DATE.sql

# Files backup
tar -czf $BACKUP_DIR/files_backup_$DATE.tar.gz /var/www/voltargego-api

# 30 günden eski backup'ları sil
find $BACKUP_DIR -name "*.sql" -mtime +30 -delete
find $BACKUP_DIR -name "*.tar.gz" -mtime +30 -delete

echo "Backup completed: $DATE"
```

### 15. Cron Job Ekleme

```bash
# Cron job ekle
sudo crontab -e

# Aşağıdaki satırları ekle:
# Günlük backup
0 2 * * * /root/backup.sh

# Laravel queue worker (eğer queue kullanıyorsanız)
* * * * * cd /var/www/voltargego-api && php artisan schedule:run >> /dev/null 2>&1
```

## 🔄 Flutter App Güncelleme

### API Service Güncelleme

```dart
// lib/core/network/api_service.dart
static const String _productionUrl = 'https://your-server-ip-or-domain.com/api';
static const String _baseUrl = _productionUrl;
```

## 📊 Performance Monitoring

### 1. Htop Kurulumu

```bash
sudo apt install htop -y
htop
```

### 2. Nginx Status

```bash
# Nginx status modülü ekle
sudo nano /etc/nginx/sites-available/voltargego

# Location bloğu ekle:
location /nginx_status {
    stub_status on;
    access_log off;
    allow 127.0.0.1;
    deny all;
}
```

### 3. MySQL Monitoring

```bash
# MySQL status kontrolü
sudo mysql -u root -p -e "SHOW STATUS LIKE 'Threads_connected';"
sudo mysql -u root -p -e "SHOW PROCESSLIST;"
```

## 🚀 Deployment Script

### deploy.sh

```bash
#!/bin/bash

echo "🚀 VoltargeGo API Deployment Started"

cd /var/www/voltargego-api

# Git pull (eğer git kullanıyorsanız)
# git pull origin main

# Composer install
composer install --no-dev --optimize-autoloader

# Cache'leri temizle
php artisan config:clear
php artisan cache:clear
php artisan route:clear
php artisan view:clear

# Migration'ları çalıştır
php artisan migrate --force

# Production optimizasyonu
php artisan config:cache
php artisan route:cache
php artisan view:cache

# İzinleri ayarla
chown -R www-data:www-data /var/www/voltargego-api
chmod -R 755 /var/www/voltargego-api
chmod -R 775 /var/www/voltargego-api/storage

# Servisleri yeniden başlat
systemctl restart nginx
systemctl restart php8.1-fpm

echo "✅ Deployment completed successfully!"
```

## 🔒 Güvenlik Kontrol Listesi

- [ ] Firewall aktif
- [ ] SSH key authentication
- [ ] SSL sertifikası
- [ ] Rate limiting
- [ ] File permissions
- [ ] Database backup
- [ ] Log monitoring
- [ ] Regular updates

Bu rehber ile sunucunuzda güvenli ve performanslı bir Laravel API'niz olacak! 🎉
