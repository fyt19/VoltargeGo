# VoltargeGo Laravel Backend Structure

## 📁 Proje Yapısı

```
voltargego-api/
├── app/
│   ├── Http/
│   │   ├── Controllers/
│   │   │   ├── Api/
│   │   │   │   ├── AuthController.php
│   │   │   │   ├── UserController.php
│   │   │   │   ├── ChargingStationController.php
│   │   │   │   ├── ReservationController.php
│   │   │   │   ├── PaymentController.php
│   │   │   │   ├── ReviewController.php
│   │   │   │   └── NotificationController.php
│   │   │   └── Controller.php
│   │   ├── Middleware/
│   │   │   ├── JwtMiddleware.php
│   │   │   ├── RateLimiter.php
│   │   │   └── Cors.php
│   │   └── Requests/
│   │       ├── LoginRequest.php
│   │       ├── RegisterRequest.php
│   │       ├── UpdateProfileRequest.php
│   │       └── CreateReservationRequest.php
│   ├── Models/
│   │   ├── User.php
│   │   ├── ChargingStation.php
│   │   ├── ChargingPoint.php
│   │   ├── Reservation.php
│   │   ├── Payment.php
│   │   ├── Review.php
│   │   └── Notification.php
│   ├── Services/
│   │   ├── AuthService.php
│   │   ├── PaymentService.php
│   │   ├── EmailService.php
│   │   └── NotificationService.php
│   ├── Repositories/
│   │   ├── UserRepository.php
│   │   ├── ChargingStationRepository.php
│   │   └── ReservationRepository.php
│   └── Traits/
│       ├── HasApiTokens.php
│       └── Searchable.php
├── database/
│   ├── migrations/
│   │   ├── 2024_01_01_000001_create_users_table.php
│   │   ├── 2024_01_01_000002_create_charging_stations_table.php
│   │   ├── 2024_01_01_000003_create_charging_points_table.php
│   │   ├── 2024_01_01_000004_create_reservations_table.php
│   │   ├── 2024_01_01_000005_create_payments_table.php
│   │   ├── 2024_01_01_000006_create_reviews_table.php
│   │   └── 2024_01_01_000007_create_notifications_table.php
│   ├── seeders/
│   │   ├── DatabaseSeeder.php
│   │   ├── UserSeeder.php
│   │   └── ChargingStationSeeder.php
│   └── factories/
│       ├── UserFactory.php
│       └── ChargingStationFactory.php
├── routes/
│   └── api.php
├── config/
│   ├── jwt.php
│   ├── cors.php
│   └── filesystems.php
├── storage/
│   └── app/
│       └── public/
│           ├── profiles/
│           └── stations/
├── public/
│   └── uploads/
├── .env
├── composer.json
└── README.md
```

## 🔧 Kurulum Komutları

### 1. Proje Oluşturma

```bash
composer create-project laravel/laravel voltargego-api
cd voltargego-api
```

### 2. Gerekli Paketler

```bash
composer require tymon/jwt-auth
composer require intervention/image
composer require spatie/laravel-permission
composer require barryvdh/laravel-cors
composer require laravel/sanctum
```

### 3. JWT Konfigürasyonu

```bash
php artisan vendor:publish --provider="Tymon\JWTAuth\Providers\LaravelServiceProvider"
php artisan jwt:secret
```

### 4. Migration'ları Çalıştırma

```bash
php artisan migrate
php artisan db:seed
```

## 📊 Veritabanı Migration'ları

### Users Table

```php
Schema::create('users', function (Blueprint $table) {
    $table->id();
    $table->string('first_name');
    $table->string('last_name');
    $table->string('email')->unique();
    $table->string('password');
    $table->string('phone')->nullable();
    $table->string('profile_image')->nullable();
    $table->integer('points')->default(0);
    $table->boolean('is_active')->default(true);
    $table->timestamp('last_login_at')->nullable();
    $table->timestamps();
});
```

### Charging Stations Table

```php
Schema::create('charging_stations', function (Blueprint $table) {
    $table->id();
    $table->string('name');
    $table->text('address');
    $table->decimal('latitude', 10, 8);
    $table->decimal('longitude', 11, 8);
    $table->text('description')->nullable();
    $table->json('images')->nullable();
    $table->enum('status', ['available', 'maintenance', 'offline'])->default('available');
    $table->decimal('rating', 3, 2)->default(0);
    $table->integer('review_count')->default(0);
    $table->json('amenities')->nullable();
    $table->json('pricing');
    $table->timestamps();

    $table->index(['latitude', 'longitude']);
    $table->spatialIndex(['latitude', 'longitude']);
});
```

### Charging Points Table

```php
Schema::create('charging_points', function (Blueprint $table) {
    $table->id();
    $table->foreignId('charging_station_id')->constrained()->onDelete('cascade');
    $table->string('type'); // AC, DC, Fast, Ultra-fast
    $table->decimal('power', 8, 2); // kW
    $table->enum('status', ['available', 'inUse', 'maintenance', 'offline'])->default('available');
    $table->foreignId('current_user_id')->nullable()->constrained('users');
    $table->timestamp('estimated_completion')->nullable();
    $table->timestamps();
});
```

### Reservations Table

```php
Schema::create('reservations', function (Blueprint $table) {
    $table->id();
    $table->foreignId('user_id')->constrained()->onDelete('cascade');
    $table->foreignId('charging_station_id')->constrained()->onDelete('cascade');
    $table->string('charging_point_id');
    $table->timestamp('start_time');
    $table->timestamp('end_time');
    $table->enum('status', ['pending', 'confirmed', 'active', 'completed', 'cancelled', 'expired'])->default('pending');
    $table->decimal('total_cost', 10, 2);
    $table->string('currency')->default('TRY');
    $table->timestamps();

    $table->index(['user_id', 'status']);
    $table->index(['start_time', 'end_time']);
});
```

## 🔐 API Routes

### routes/api.php

```php
<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\UserController;
use App\Http\Controllers\Api\ChargingStationController;
use App\Http\Controllers\Api\ReservationController;
use App\Http\Controllers\Api\PaymentController;
use App\Http\Controllers\Api\ReviewController;
use App\Http\Controllers\Api\NotificationController;

// Public routes
Route::prefix('auth')->group(function () {
    Route::post('register', [AuthController::class, 'register']);
    Route::post('login', [AuthController::class, 'login']);
    Route::post('forgot-password', [AuthController::class, 'forgotPassword']);
});

Route::get('charging-stations', [ChargingStationController::class, 'index']);
Route::get('charging-stations/{id}', [ChargingStationController::class, 'show']);

// Protected routes
Route::middleware('auth:api')->group(function () {
    // Auth
    Route::post('auth/logout', [AuthController::class, 'logout']);
    Route::post('auth/refresh', [AuthController::class, 'refresh']);

    // User
    Route::prefix('user')->group(function () {
        Route::get('profile', [UserController::class, 'profile']);
        Route::put('profile', [UserController::class, 'updateProfile']);
        Route::get('stats', [UserController::class, 'stats']);
    });

    // Charging Stations
    Route::prefix('charging-stations')->group(function () {
        Route::get('{id}/reviews', [ChargingStationController::class, 'reviews']);
        Route::post('{id}/reviews', [ChargingStationController::class, 'addReview']);
    });

    // Reservations
    Route::prefix('reservations')->group(function () {
        Route::get('/', [ReservationController::class, 'index']);
        Route::post('/', [ReservationController::class, 'store']);
        Route::get('{id}', [ReservationController::class, 'show']);
        Route::put('{id}/cancel', [ReservationController::class, 'cancel']);
    });

    // Payments
    Route::prefix('payment')->group(function () {
        Route::get('methods', [PaymentController::class, 'methods']);
        Route::post('methods', [PaymentController::class, 'addMethod']);
        Route::delete('methods/{id}', [PaymentController::class, 'deleteMethod']);
        Route::post('process', [PaymentController::class, 'process']);
    });

    // Reviews
    Route::prefix('ratings')->group(function () {
        Route::get('user', [ReviewController::class, 'userRatings']);
        Route::post('/', [ReviewController::class, 'store']);
    });

    // Notifications
    Route::prefix('notifications')->group(function () {
        Route::get('/', [NotificationController::class, 'index']);
        Route::put('{id}/read', [NotificationController::class, 'markAsRead']);
    });
});
```

## 🎯 Controller Örnekleri

### AuthController

```php
<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\LoginRequest;
use App\Http\Requests\RegisterRequest;
use App\Services\AuthService;
use Illuminate\Http\JsonResponse;

class AuthController extends Controller
{
    protected $authService;

    public function __construct(AuthService $authService)
    {
        $this->authService = $authService;
    }

    public function register(RegisterRequest $request): JsonResponse
    {
        $result = $this->authService->register($request->validated());

        return response()->json($result, 201);
    }

    public function login(LoginRequest $request): JsonResponse
    {
        $result = $this->authService->login($request->validated());

        if (!$result['success']) {
            return response()->json($result, 401);
        }

        return response()->json($result);
    }

    public function logout(): JsonResponse
    {
        auth()->logout();

        return response()->json(['message' => 'Başarıyla çıkış yapıldı']);
    }

    public function refresh(): JsonResponse
    {
        $token = auth()->refresh();

        return response()->json([
            'token' => $token,
            'expires_in' => auth()->factory()->getTTL() * 60
        ]);
    }

    public function forgotPassword(Request $request): JsonResponse
    {
        $request->validate(['email' => 'required|email']);

        $result = $this->authService->forgotPassword($request->email);

        return response()->json($result);
    }
}
```

## 🔧 Nginx Konfigürasyonu

### /etc/nginx/sites-available/voltargego

```nginx
server {
    listen 80;
    server_name your-domain.com;
    root /var/www/voltargego-api/public;
    index index.php index.html index.htm;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~ /\.(?!well-known).* {
        deny all;
    }

    # API rate limiting
    location /api/ {
        limit_req zone=api burst=20 nodelay;
        limit_req_status 429;
    }
}

# Rate limiting
limit_req_zone $binary_remote_addr zone=api:10m rate=10r/s;
```

## 🚀 Deployment Script

### deploy.sh

```bash
#!/bin/bash

echo "🚀 VoltargeGo API Deployment Started"

# Pull latest changes
git pull origin main

# Install dependencies
composer install --no-dev --optimize-autoloader

# Clear caches
php artisan config:clear
php artisan cache:clear
php artisan route:clear
php artisan view:clear

# Run migrations
php artisan migrate --force

# Optimize for production
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Set permissions
sudo chown -R www-data:www-data /var/www/voltargego-api
sudo chmod -R 755 /var/www/voltargego-api
sudo chmod -R 775 /var/www/voltargego-api/storage

# Restart services
sudo systemctl restart nginx
sudo systemctl restart php8.1-fpm

echo "✅ Deployment completed successfully!"
```

## 📊 Performance Optimizations

### 1. Redis Cache

```bash
# Redis kurulumu
sudo apt install redis-server

# Laravel Redis konfigürasyonu
composer require predis/predis
```

### 2. Database Indexing

```sql
-- Users table
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_last_login ON users(last_login_at);

-- Charging stations table
CREATE INDEX idx_stations_location ON charging_stations(latitude, longitude);
CREATE INDEX idx_stations_status ON charging_stations(status);

-- Reservations table
CREATE INDEX idx_reservations_user_status ON reservations(user_id, status);
CREATE INDEX idx_reservations_time ON reservations(start_time, end_time);
```

### 3. Queue System

```bash
# Queue worker kurulumu
php artisan queue:work --daemon

# Supervisor konfigürasyonu
sudo apt install supervisor
```

Bu yapı ile modern, ölçeklenebilir ve güvenli bir Laravel API'niz olacak! 🎉
