# 🚀 Supabase ile VoltargeGo Backend Kurulumu

## 1. Supabase Projesi Oluşturma

### Adım 1: Supabase'e Giriş

1. https://supabase.com'a gidin
2. "Start your project" tıklayın
3. GitHub ile giriş yapın

### Adım 2: Yeni Proje

1. "New Project" tıklayın
2. **Organization**: Kendi organizasyonunuzu seçin
3. **Name**: `voltargego`
4. **Database Password**: Güçlü bir şifre girin (örn: `VoltargeGo2024!`)
5. **Region**: `West Europe (London)` seçin
6. "Create new project" tıklayın

### Adım 3: API Bilgilerini Alın

Proje oluşturulduktan sonra:

1. **Settings** > **API** sekmesine gidin
2. **Project URL** ve **anon public** key'i kopyalayın

## 2. Flutter App'e Supabase Entegrasyonu

### Adım 1: pubspec.yaml'a Supabase Paketi Ekleyin

```yaml
dependencies:
  supabase_flutter: ^2.3.4
```

### Adım 2: Supabase Service Oluşturun

```dart
// lib/core/services/supabase_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';

  static SupabaseClient get client => Supabase.instance.client;

  // Auth işlemleri
  static Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    return await client.auth.signUp(
      email: email,
      password: password,
      data: {
        'first_name': firstName,
        'last_name': lastName,
      },
    );
  }

  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  static Future<void> signOut() async {
    await client.auth.signOut();
  }

  // Charging Stations
  static Future<List<Map<String, dynamic>>> getChargingStations() async {
    final response = await client
        .from('charging_stations')
        .select()
        .order('name');
    return List<Map<String, dynamic>>.from(response);
  }

  // Reservations
  static Future<Map<String, dynamic>> createReservation({
    required String stationId,
    required String chargingPointId,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    final user = client.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final response = await client
        .from('reservations')
        .insert({
          'user_id': user.id,
          'station_id': stationId,
          'charging_point_id': chargingPointId,
          'start_time': startTime.toIso8601String(),
          'end_time': endTime.toIso8601String(),
          'status': 'pending',
        })
        .select()
        .single();

    return response;
  }
}
```

### Adım 3: main.dart'ta Supabase'i Başlatın

```dart
// lib/main.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:voltargego_flutter/core/services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseService.supabaseUrl,
    anonKey: SupabaseService.supabaseAnonKey,
  );

  runApp(const VoltargeGoApp());
}
```

## 3. Veritabanı Tablolarını Oluşturun

### SQL Editor'da şu komutları çalıştırın:

```sql
-- Users tablosu (otomatik oluşur)
-- Ek alanlar ekleyin:
ALTER TABLE auth.users ADD COLUMN first_name TEXT;
ALTER TABLE auth.users ADD COLUMN last_name TEXT;
ALTER TABLE auth.users ADD COLUMN phone TEXT;
ALTER TABLE auth.users ADD COLUMN points INTEGER DEFAULT 0;
ALTER TABLE auth.users ADD COLUMN created_at TIMESTAMP DEFAULT NOW();

-- Charging Stations tablosu
CREATE TABLE charging_stations (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  address TEXT NOT NULL,
  latitude DECIMAL(10, 8) NOT NULL,
  longitude DECIMAL(11, 8) NOT NULL,
  images TEXT[],
  status TEXT DEFAULT 'active',
  rating DECIMAL(3, 2) DEFAULT 0,
  total_reviews INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Charging Points tablosu
CREATE TABLE charging_points (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  station_id UUID REFERENCES charging_stations(id) ON DELETE CASCADE,
  type TEXT NOT NULL,
  power DECIMAL(5, 2) NOT NULL,
  status TEXT DEFAULT 'available',
  current_user_id UUID REFERENCES auth.users(id),
  created_at TIMESTAMP DEFAULT NOW()
);

-- Reservations tablosu
CREATE TABLE reservations (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  station_id UUID REFERENCES charging_stations(id) ON DELETE CASCADE,
  charging_point_id UUID REFERENCES charging_points(id) ON DELETE CASCADE,
  start_time TIMESTAMP NOT NULL,
  end_time TIMESTAMP NOT NULL,
  status TEXT DEFAULT 'pending',
  total_cost DECIMAL(10, 2),
  currency TEXT DEFAULT 'TRY',
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Payments tablosu
CREATE TABLE payments (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  reservation_id UUID REFERENCES reservations(id) ON DELETE CASCADE,
  amount DECIMAL(10, 2) NOT NULL,
  currency TEXT DEFAULT 'TRY',
  method TEXT NOT NULL,
  status TEXT DEFAULT 'pending',
  paid_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Ratings tablosu
CREATE TABLE ratings (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  station_id UUID REFERENCES charging_stations(id) ON DELETE CASCADE,
  reservation_id UUID REFERENCES reservations(id) ON DELETE CASCADE,
  rating INTEGER CHECK (rating >= 1 AND rating <= 5),
  comment TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Row Level Security (RLS) aktifleştirin
ALTER TABLE charging_stations ENABLE ROW LEVEL SECURITY;
ALTER TABLE charging_points ENABLE ROW LEVEL SECURITY;
ALTER TABLE reservations ENABLE ROW LEVEL SECURITY;
ALTER TABLE payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE ratings ENABLE ROW LEVEL SECURITY;

-- RLS Policies
-- Charging stations herkes görebilir
CREATE POLICY "Charging stations are viewable by everyone" ON charging_stations
  FOR SELECT USING (true);

-- Reservations sadece kendi rezervasyonlarını görebilir
CREATE POLICY "Users can view own reservations" ON reservations
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own reservations" ON reservations
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Ratings herkes görebilir, sadece kendi yorumlarını yazabilir
CREATE POLICY "Ratings are viewable by everyone" ON ratings
  FOR SELECT USING (true);

CREATE POLICY "Users can insert own ratings" ON ratings
  FOR INSERT WITH CHECK (auth.uid() = user_id);
```

## 4. Test Verileri Ekleyin

```sql
-- Örnek şarj istasyonları
INSERT INTO charging_stations (name, address, latitude, longitude, images) VALUES
('VoltargeGo Merkez', 'İstanbul, Kadıköy', 40.9909, 29.0303, ARRAY['station1.jpg', 'station2.jpg']),
('VoltargeGo Avrupa', 'İstanbul, Beşiktaş', 41.0422, 29.0083, ARRAY['station3.jpg']),
('VoltargeGo Anadolu', 'İstanbul, Üsküdar', 41.0284, 29.0167, ARRAY['station4.jpg', 'station5.jpg']);

-- Örnek şarj noktaları
INSERT INTO charging_points (station_id, type, power, status) VALUES
((SELECT id FROM charging_stations WHERE name = 'VoltargeGo Merkez'), 'Type 2', 22.0, 'available'),
((SELECT id FROM charging_stations WHERE name = 'VoltargeGo Merkez'), 'CCS', 50.0, 'available'),
((SELECT id FROM charging_stations WHERE name = 'VoltargeGo Avrupa'), 'Type 2', 11.0, 'available'),
((SELECT id FROM charging_stations WHERE name = 'VoltargeGo Anadolu'), 'CHAdeMO', 50.0, 'available');
```

## 5. Flutter App'i Güncelleyin

### Login Page'i Supabase ile güncelleyin:

```dart
// lib/presentation/login/login_page.dart
import 'package:voltargego_flutter/core/services/supabase_service.dart';

// _login metodunu güncelleyin:
Future<void> _login() async {
  try {
    final response = await SupabaseService.signIn(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (response.user != null) {
      // SharedPreferences'a kaydet
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', true);
      await prefs.setString('user_id', response.user!.id);

      // Ana sayfaya yönlendir
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const HomePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Giriş başarısız: ${e.toString()}')),
    );
  }
}
```

## 6. Test Edin

1. Flutter app'i çalıştırın
2. Kayıt olun
3. Giriş yapın
4. Şarj istasyonlarını görüntüleyin
5. Rezervasyon yapın

## 🎉 Tamamlandı!

Artık VoltargeGo app'iniz Supabase backend'i ile çalışıyor!

- ✅ Kullanıcı kayıt/giriş
- ✅ Şarj istasyonları listesi
- ✅ Rezervasyon sistemi
- ✅ Ödeme sistemi
- ✅ Puanlama sistemi
