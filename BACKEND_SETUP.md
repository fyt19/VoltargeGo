# VoltargeGo Backend Setup Guide

## 🚀 Backend Gereksinimleri

### Teknolojiler

- **Node.js** (v18+)
- **Express.js** (Web framework)
- **MongoDB** (Veritabanı)
- **JWT** (Authentication)
- **bcrypt** (Password hashing)
- **Multer** (File uploads)
- **Nodemailer** (Email service)

### Önerilen Hosting Platformları

- **Heroku** (Ücretsiz tier mevcut)
- **Railway** (Ücretsiz tier mevcut)
- **Render** (Ücretsiz tier mevcut)
- **DigitalOcean** (Ücretli)
- **AWS** (Ücretli)

## 📁 Backend Proje Yapısı

```
voltargego-backend/
├── src/
│   ├── controllers/
│   │   ├── authController.js
│   │   ├── userController.js
│   │   ├── stationController.js
│   │   ├── reservationController.js
│   │   ├── paymentController.js
│   │   └── reviewController.js
│   ├── models/
│   │   ├── User.js
│   │   ├── ChargingStation.js
│   │   ├── Reservation.js
│   │   ├── Payment.js
│   │   └── Review.js
│   ├── routes/
│   │   ├── auth.js
│   │   ├── user.js
│   │   ├── stations.js
│   │   ├── reservations.js
│   │   ├── payments.js
│   │   └── reviews.js
│   ├── middleware/
│   │   ├── auth.js
│   │   ├── upload.js
│   │   └── validation.js
│   ├── utils/
│   │   ├── emailService.js
│   │   ├── paymentService.js
│   │   └── notificationService.js
│   └── config/
│       ├── database.js
│       └── environment.js
├── package.json
├── .env
└── README.md
```

## 🔧 Kurulum Adımları

### 1. Proje Oluşturma

```bash
mkdir voltargego-backend
cd voltargego-backend
npm init -y
```

### 2. Gerekli Paketlerin Kurulumu

```bash
npm install express mongoose bcryptjs jsonwebtoken cors dotenv multer nodemailer
npm install --save-dev nodemon
```

### 3. Environment Variables (.env)

```env
# Server
PORT=5140
NODE_ENV=development

# Database
MONGODB_URI=mongodb://localhost:27017/voltargego
MONGODB_URI_PROD=mongodb+srv://username:password@cluster.mongodb.net/voltargego

# JWT
JWT_SECRET=your-super-secret-jwt-key
JWT_EXPIRE=7d

# Email (Gmail için)
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_USER=your-email@gmail.com
EMAIL_PASS=your-app-password

# Payment (Stripe için)
STRIPE_SECRET_KEY=sk_test_...
STRIPE_PUBLISHABLE_KEY=pk_test_...

# File Upload
UPLOAD_PATH=./uploads
MAX_FILE_SIZE=5242880
```

## 📊 Veritabanı Şemaları

### User Schema

```javascript
const userSchema = new mongoose.Schema({
  firstName: { type: String, required: true },
  lastName: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  phone: String,
  profileImage: String,
  points: { type: Number, default: 0 },
  isActive: { type: Boolean, default: true },
  lastLoginAt: { type: Date, default: Date.now },
  createdAt: { type: Date, default: Date.now },
  updatedAt: { type: Date, default: Date.now },
});
```

### ChargingStation Schema

```javascript
const chargingStationSchema = new mongoose.Schema({
  name: { type: String, required: true },
  address: { type: String, required: true },
  location: {
    type: { type: String, default: "Point" },
    coordinates: [Number], // [longitude, latitude]
  },
  description: String,
  images: [String],
  chargingPoints: [
    {
      type: { type: String, required: true },
      power: { type: Number, required: true },
      status: {
        type: String,
        enum: ["available", "inUse", "maintenance", "offline"],
        default: "available",
      },
      currentUser: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
      estimatedCompletion: Date,
    },
  ],
  status: {
    type: String,
    enum: ["available", "maintenance", "offline"],
    default: "available",
  },
  rating: { type: Number, default: 0 },
  reviewCount: { type: Number, default: 0 },
  amenities: [String],
  pricing: {
    pricePerKwh: { type: Number, required: true },
    connectionFee: Number,
    parkingFee: Number,
    currency: { type: String, default: "TRY" },
  },
  createdAt: { type: Date, default: Date.now },
  updatedAt: { type: Date, default: Date.now },
});
```

### Reservation Schema

```javascript
const reservationSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
  stationId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "ChargingStation",
    required: true,
  },
  chargingPointId: { type: String, required: true },
  startTime: { type: Date, required: true },
  endTime: { type: Date, required: true },
  status: {
    type: String,
    enum: [
      "pending",
      "confirmed",
      "active",
      "completed",
      "cancelled",
      "expired",
    ],
    default: "pending",
  },
  totalCost: { type: Number, required: true },
  currency: { type: String, default: "TRY" },
  payment: {
    id: String,
    status: {
      type: String,
      enum: ["pending", "paid", "failed", "refunded"],
      default: "pending",
    },
    method: String,
    amount: Number,
    currency: String,
    paidAt: Date,
    transactionId: String,
  },
  createdAt: { type: Date, default: Date.now },
  updatedAt: { type: Date, default: Date.now },
});
```

## 🔐 API Endpoints

### Authentication

- `POST /api/auth/register` - Kullanıcı kaydı
- `POST /api/auth/login` - Kullanıcı girişi
- `POST /api/auth/logout` - Çıkış
- `POST /api/auth/forgot-password` - Şifre sıfırlama

### User Management

- `GET /api/user/profile` - Kullanıcı profili
- `PUT /api/user/profile` - Profil güncelleme
- `GET /api/user/stats` - Kullanıcı istatistikleri

### Charging Stations

- `GET /api/charging-stations` - İstasyon listesi
- `GET /api/charging-stations/:id` - İstasyon detayı
- `GET /api/charging-stations/:id/reviews` - İstasyon yorumları
- `POST /api/charging-stations/:id/reviews` - Yorum ekleme

### Reservations

- `POST /api/reservations` - Rezervasyon oluşturma
- `GET /api/reservations` - Kullanıcı rezervasyonları
- `GET /api/reservations/:id` - Rezervasyon detayı
- `PUT /api/reservations/:id/cancel` - Rezervasyon iptali

### Payments

- `GET /api/payment/methods` - Ödeme yöntemleri
- `POST /api/payment/methods` - Ödeme yöntemi ekleme
- `DELETE /api/payment/methods/:id` - Ödeme yöntemi silme
- `POST /api/payment/process` - Ödeme işlemi

### Reviews & Ratings

- `GET /api/ratings/user` - Kullanıcı puanları
- `POST /api/ratings` - Puan verme

### Notifications

- `GET /api/notifications` - Bildirimler
- `PUT /api/notifications/:id/read` - Bildirim okundu

## 🌐 Production Deployment

### 1. Heroku Deployment

```bash
# Heroku CLI kurulumu
npm install -g heroku

# Login
heroku login

# App oluşturma
heroku create voltargego-backend

# Environment variables
heroku config:set MONGODB_URI_PROD=your-mongodb-uri
heroku config:set JWT_SECRET=your-jwt-secret
heroku config:set NODE_ENV=production

# Deploy
git add .
git commit -m "Initial deployment"
git push heroku main
```

### 2. Railway Deployment

1. Railway.app'e giriş yapın
2. "New Project" > "Deploy from GitHub repo"
3. Repository'yi seçin
4. Environment variables'ları ekleyin
5. Deploy edin

### 3. Render Deployment

1. Render.com'a giriş yapın
2. "New Web Service" > GitHub repo seçin
3. Build command: `npm install`
4. Start command: `npm start`
5. Environment variables'ları ekleyin

## 🔄 Flutter App Güncelleme

Production'a geçtikten sonra Flutter app'te:

```dart
// lib/core/network/api_service.dart
static const String _productionUrl = 'https://your-backend-domain.com/api';

// Production'a geçiş
ApiService().switchToProduction();
```

## 📱 Test Etme

### Postman Collection

```json
{
  "info": {
    "name": "VoltargeGo API",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "item": [
    {
      "name": "Auth",
      "item": [
        {
          "name": "Register",
          "request": {
            "method": "POST",
            "url": "{{baseUrl}}/auth/register",
            "body": {
              "mode": "raw",
              "raw": "{\n  \"firstName\": \"John\",\n  \"lastName\": \"Doe\",\n  \"email\": \"john@example.com\",\n  \"password\": \"123456\"\n}",
              "options": {
                "raw": {
                  "language": "json"
                }
              }
            }
          }
        }
      ]
    }
  ]
}
```

## 🔒 Güvenlik Önlemleri

1. **JWT Token Expiration** - 7 gün
2. **Password Hashing** - bcrypt ile
3. **Rate Limiting** - API abuse önleme
4. **CORS Configuration** - Domain kısıtlaması
5. **Input Validation** - Tüm input'ları validate et
6. **HTTPS** - Production'da zorunlu

## 📈 Monitoring & Logging

### Winston Logger

```javascript
const winston = require("winston");

const logger = winston.createLogger({
  level: "info",
  format: winston.format.json(),
  transports: [
    new winston.transports.File({ filename: "error.log", level: "error" }),
    new winston.transports.File({ filename: "combined.log" }),
  ],
});
```

### Health Check Endpoint

```javascript
app.get("/health", (req, res) => {
  res.status(200).json({
    status: "OK",
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
  });
});
```

## 🚀 Performance Optimizations

1. **Database Indexing** - Sık sorgulanan alanlar
2. **Caching** - Redis ile
3. **Pagination** - Büyük listeler için
4. **Image Compression** - Upload edilen resimler
5. **CDN** - Statik dosyalar için

Bu rehber ile backend'inizi kurup production'a deploy edebilirsiniz! 🎉
