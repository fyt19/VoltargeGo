# 🗄️ Supabase Veritabanı Kurulumu

## 1. Supabase Dashboard'a Gidin

1. https://supabase.com'a gidin
2. Projenizi seçin
3. **SQL Editor** sekmesine tıklayın

## 2. Veritabanı Tablolarını Oluşturun

### Adım 1: Users Tablosu Güncellemesi

```sql
-- Users tablosuna ek alanlar ekleyin
ALTER TABLE auth.users ADD COLUMN IF NOT EXISTS first_name TEXT;
ALTER TABLE auth.users ADD COLUMN IF NOT EXISTS last_name TEXT;
ALTER TABLE auth.users ADD COLUMN IF NOT EXISTS phone TEXT;
ALTER TABLE auth.users ADD COLUMN IF NOT EXISTS points INTEGER DEFAULT 0;
ALTER TABLE auth.users ADD COLUMN IF NOT EXISTS avatar_url TEXT;
ALTER TABLE auth.users ADD COLUMN IF NOT EXISTS created_at TIMESTAMP DEFAULT NOW();
```

### Adım 2: Charging Stations Tablosu

```sql
-- Charging Stations tablosu
CREATE TABLE IF NOT EXISTS charging_stations (
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
```

### Adım 3: Charging Points Tablosu

```sql
-- Charging Points tablosu
CREATE TABLE IF NOT EXISTS charging_points (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  station_id UUID REFERENCES charging_stations(id) ON DELETE CASCADE,
  type TEXT NOT NULL,
  power DECIMAL(5, 2) NOT NULL,
  status TEXT DEFAULT 'available',
  current_user_id UUID REFERENCES auth.users(id),
  created_at TIMESTAMP DEFAULT NOW()
);
```

### Adım 4: Reservations Tablosu

```sql
-- Reservations tablosu
CREATE TABLE IF NOT EXISTS reservations (
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
```

### Adım 5: Payments Tablosu

```sql
-- Payments tablosu
CREATE TABLE IF NOT EXISTS payments (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  reservation_id UUID REFERENCES reservations(id) ON DELETE CASCADE,
  amount DECIMAL(10, 2) NOT NULL,
  currency TEXT DEFAULT 'TRY',
  method TEXT NOT NULL,
  status TEXT DEFAULT 'pending',
  paid_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT NOW()
);
```

### Adım 6: Ratings Tablosu

```sql
-- Ratings tablosu
CREATE TABLE IF NOT EXISTS ratings (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  station_id UUID REFERENCES charging_stations(id) ON DELETE CASCADE,
  reservation_id UUID REFERENCES reservations(id) ON DELETE CASCADE,
  rating INTEGER CHECK (rating >= 1 AND rating <= 5),
  comment TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);
```

## 3. Row Level Security (RLS) Aktifleştirin

```sql
-- RLS aktifleştirin
ALTER TABLE charging_stations ENABLE ROW LEVEL SECURITY;
ALTER TABLE charging_points ENABLE ROW LEVEL SECURITY;
ALTER TABLE reservations ENABLE ROW LEVEL SECURITY;
ALTER TABLE payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE ratings ENABLE ROW LEVEL SECURITY;
```

## 4. RLS Policies Oluşturun

```sql
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

## 5. Test Verileri Ekleyin

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

## 6. Storage Bucket Oluşturun

1. **Storage** sekmesine gidin
2. **New bucket** butonuna tıklayın
3. **Bucket name**: `avatars`
4. **Public bucket** seçeneğini işaretleyin
5. **Create bucket** butonuna tıklayın

## 7. Storage Policies

```sql
-- Avatar bucket için public read policy
CREATE POLICY "Avatar images are publicly accessible" ON storage.objects
  FOR SELECT USING (bucket_id = 'avatars');

-- Kullanıcılar sadece kendi avatar'larını yükleyebilir
CREATE POLICY "Users can upload own avatars" ON storage.objects
  FOR INSERT WITH CHECK (
    bucket_id = 'avatars' AND
    auth.uid()::text = (storage.foldername(name))[1]
  );

-- Kullanıcılar sadece kendi avatar'larını güncelleyebilir
CREATE POLICY "Users can update own avatars" ON storage.objects
  FOR UPDATE USING (
    bucket_id = 'avatars' AND
    auth.uid()::text = (storage.foldername(name))[1]
  );

-- Kullanıcılar sadece kendi avatar'larını silebilir
CREATE POLICY "Users can delete own avatars" ON storage.objects
  FOR DELETE USING (
    bucket_id = 'avatars' AND
    auth.uid()::text = (storage.foldername(name))[1]
  );
```

## 🎉 Tamamlandı!

Artık Supabase veritabanınız VoltargeGo için hazır! Kullanıcılar:

- ✅ Kayıt olabilir
- ✅ Profil fotoğrafı yükleyebilir
- ✅ Rezervasyon yapabilir
- ✅ Puanlama yapabilir
- ✅ Ödeme yapabilir
