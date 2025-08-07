#!/bin/bash

echo "🚀 VoltargeGo API Setup for voltargego.duyari.com.tr"
echo "===================================================="

# Domain bilgileri
DOMAIN="voltargego.duyari.com.tr"
API_URL="https://voltargego.duyari.com.tr/api"

# Kullanıcıdan bilgileri al
read -p "MySQL root şifresini girin: " MYSQL_ROOT_PASS
read -p "VoltargeGo veritabanı şifresini girin: " DB_PASS
read -p "Gmail adresinizi girin: " EMAIL
read -p "Gmail app şifrenizi girin: " EMAIL_PASS

echo "📦 Sistem güncellemesi yapılıyor..."
sudo apt update && sudo apt upgrade -y
sudo apt install curl wget git unzip software-properties-common -y

echo "🐘 PHP 8.1 kuruluyor..."
sudo add-apt-repository ppa:ondrej/php -y
sudo apt update
sudo apt install php8.1 php8.1-fpm php8.1-mysql php8.1-xml php8.1-curl php8.1-mbstring php8.1-zip php8.1-bcmath php8.1-gd php8.1-redis php8.1-intl -y

echo "⚙️ PHP konfigürasyonu yapılıyor..."
sudo sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 10M/' /etc/php/8.1/fpm/php.ini
sudo sed -i 's/post_max_size = 8M/post_max_size = 10M/' /etc/php/8.1/fpm/php.ini
sudo sed -i 's/memory_limit = 128M/memory_limit = 256M/' /etc/php/8.1/fpm/php.ini

echo "🎼 Composer kuruluyor..."
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
sudo chmod +x /usr/local/bin/composer

echo "🗄️ MySQL kuruluyor..."
sudo apt install mysql-server -y
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$MYSQL_ROOT_PASS';"
sudo mysql -e "CREATE DATABASE voltargego CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
sudo mysql -e "CREATE USER 'voltargego_user'@'localhost' IDENTIFIED BY '$DB_PASS';"
sudo mysql -e "GRANT ALL PRIVILEGES ON voltargego.* TO 'voltargego_user'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

echo "🌐 Nginx kuruluyor..."
sudo apt install nginx -y
sudo systemctl enable nginx
sudo systemctl start nginx

echo "📁 Laravel projesi oluşturuluyor..."
cd /var/www
sudo composer create-project laravel/laravel voltargego-api
sudo chown -R www-data:www-data voltargego-api
sudo chmod -R 755 voltargego-api
sudo chmod -R 775 voltargego-api/storage
sudo chmod -R 775 voltargego-api/bootstrap/cache

echo "🔧 Laravel konfigürasyonu yapılıyor..."
cd /var/www/voltargego-api
sudo cp .env.example .env

# .env dosyasını güncelle
sudo sed -i "s|APP_URL=http://localhost|APP_URL=https://$DOMAIN|g" .env
sudo sed -i "s|DB_DATABASE=laravel|DB_DATABASE=voltargego|g" .env
sudo sed -i "s|DB_USERNAME=root|DB_USERNAME=voltargego_user|g" .env
sudo sed -i "s|DB_PASSWORD=|DB_PASSWORD=$DB_PASS|g" .env
sudo sed -i "s|MAIL_USERNAME=|MAIL_USERNAME=$EMAIL|g" .env
sudo sed -i "s|MAIL_PASSWORD=|MAIL_PASSWORD=$EMAIL_PASS|g" .env
sudo sed -i "s|MAIL_FROM_ADDRESS=|MAIL_FROM_ADDRESS=$EMAIL|g" .env

echo "🔑 Laravel key ve JWT secret oluşturuluyor..."
sudo php artisan key:generate
sudo php artisan jwt:secret

echo "📦 Gerekli paketler kuruluyor..."
sudo composer require tymon/jwt-auth
sudo composer require intervention/image
sudo composer require spatie/laravel-permission
sudo composer require barryvdh/laravel-cors

echo "🗃️ Migration'lar çalıştırılıyor..."
sudo php artisan migrate
sudo php artisan storage:link

echo "⚡ Cache'ler temizleniyor..."
sudo php artisan config:clear
sudo php artisan cache:clear
sudo php artisan route:clear
sudo php artisan view:clear

echo "🚀 Production optimizasyonu yapılıyor..."
sudo php artisan config:cache
sudo php artisan route:cache
sudo php artisan view:cache

echo "🌐 Nginx konfigürasyonu oluşturuluyor..."
sudo tee /etc/nginx/sites-available/voltargego > /dev/null <<EOF
server {
    listen 80;
    server_name $DOMAIN;
    root /var/www/voltargego-api/public;
    index index.php index.html index.htm;

    # Gzip sıkıştırma
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_proxied expired no-cache no-store private must-revalidate auth;
    gzip_types text/plain text/css text/xml text/javascript application/x-javascript application/xml+rss application/javascript;

    # API rate limiting
    limit_req_zone \$binary_remote_addr zone=api:10m rate=10r/s;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php\$ {
        fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME \$realpath_root\$fastcgi_script_name;
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
    location ~* \.(jpg|jpeg|png|gif|ico|css|js|pdf|txt)\$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # Upload limit
    client_max_body_size 10M;
}
EOF

echo "🔗 Nginx site aktifleştiriliyor..."
sudo ln -s /etc/nginx/sites-available/voltargego /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default
sudo nginx -t
sudo systemctl restart nginx

echo "🔒 Firewall konfigürasyonu..."
sudo apt install ufw -y
sudo ufw allow ssh
sudo ufw allow 80
sudo ufw allow 443
sudo ufw --force enable

echo "🔐 SSL sertifikası kuruluyor..."
sudo apt install certbot python3-certbot-nginx -y
sudo certbot --nginx -d $DOMAIN --non-interactive --agree-tos --email $EMAIL

echo "📋 Kurulum tamamlandı!"
echo "🌐 API URL: $API_URL"
echo "🔧 Flutter app'te şu değişikliği yapın:"
echo "lib/core/network/api_service.dart dosyasında:"
echo "static const String _productionUrl = '$API_URL';"
echo "static const String _baseUrl = _productionUrl;"

echo ""
echo "✅ VoltargeGo API başarıyla kuruldu!"
echo "📊 Monitoring için: htop"
echo "📝 Loglar için: tail -f /var/www/voltargego-api/storage/logs/laravel.log"
echo "🌐 Test için: curl -X GET $API_URL/charging-stations"

# Flutter app için API URL güncelleme dosyası oluştur
echo "📱 Flutter app için API URL güncelleme:"
cat > flutter_api_update.txt <<EOF
Flutter app'te şu değişikliği yapın:

lib/core/network/api_service.dart dosyasında:

// Eski:
static const String _productionUrl = 'https://your-backend-domain.com/api';

// Yeni:
static const String _productionUrl = '$API_URL';
static const String _baseUrl = _productionUrl;

Bu değişiklikten sonra Flutter app'iniz voltargego.duyari.com.tr domain'ine bağlanacak.
EOF

echo "📄 flutter_api_update.txt dosyası oluşturuldu!" 