# 📁 Supabase Storage Kurulumu

## Sorun: "No host specified in URI file:///"

Bu hata profil fotoğrafı yüklenirken oluşuyor. Çözüm için:

## 1. Storage Bucket Oluşturun

### Adım 1: Supabase Dashboard'da

1. **Supabase Dashboard**'a gidin
2. Sol menüden **Storage** sekmesine tıklayın
3. **New bucket** butonuna tıklayın

### Adım 2: Bucket Ayarları

- **Bucket name**: `avatars`
- **Public bucket**: ✅ (İşaretleyin)
- **File size limit**: `10MB`
- **Allowed MIME types**: `image/*`

### Adım 3: Create Bucket

**Create bucket** butonuna tıklayın

## 2. Storage Policies Oluşturun

### SQL Editor'da şu komutları çalıştırın:

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

## 3. Supabase Service'i Düzeltelim

### Sorun: Dosya yolu hatalı

### Çözüm: uploadProfileImage metodunu güncelleyin

```dart
// Profil fotoğrafı yükle
static Future<String> uploadProfileImage(String filePath) async {
  final user = client.auth.currentUser;
  if (user == null) throw Exception('User not authenticated');

  try {
    final fileName = 'profile_${user.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final file = File(filePath);

    // Dosyanın var olduğunu kontrol et
    if (!await file.exists()) {
      throw Exception('Dosya bulunamadı: $filePath');
    }

    // Storage'a yükle
    await client.storage
        .from('avatars')
        .upload(fileName, file);

    // Public URL al
    final imageUrl = client.storage
        .from('avatars')
        .getPublicUrl(fileName);

    // Kullanıcı metadata'sını güncelle
    await client.auth.updateUser(
      UserAttributes(
        data: {
          'avatar_url': imageUrl,
        },
      ),
    );

    return imageUrl;
  } catch (e) {
    print('Profil fotoğrafı yükleme hatası: $e');
    throw Exception('Profil fotoğrafı yüklenemedi: $e');
  }
}
```

## 4. Test Edin

### Adım 1: Storage Bucket Kontrolü

1. **Storage** sekmesine gidin
2. `avatars` bucket'ının var olduğunu kontrol edin
3. **Public** olduğunu kontrol edin

### Adım 2: Flutter App'te Test

1. **Profil sayfasına** gidin
2. **Fotoğraf seç** butonuna tıklayın
3. Galeriden bir fotoğraf seçin
4. **Kaydet** butonuna tıklayın

### Adım 3: Kontrol

1. **Storage** > **avatars** bucket'ına gidin
2. Yüklenen dosyayı göreceksiniz
3. **Public URL**'i kopyalayın ve tarayıcıda açın

## 5. Alternatif Çözüm - Default Avatar

### Eğer hala çalışmıyorsa, default avatar kullanın:

```dart
// Profil fotoğrafı yoksa default avatar göster
Widget _buildAvatar() {
  if (_userProfile?['avatar_url'] != null &&
      _userProfile!['avatar_url'].isNotEmpty) {
    return CircleAvatar(
      radius: 24,
      backgroundImage: NetworkImage(_userProfile!['avatar_url']),
      onBackgroundImageError: (exception, stackTrace) {
        // Hata durumunda default avatar göster
        setState(() {
          _userProfile!['avatar_url'] = '';
        });
      },
    );
  } else {
    return CircleAvatar(
      radius: 24,
      backgroundColor: const Color(0xFF00D9D9),
      child: Text(
        _getInitials(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
```

## 🎯 Hızlı Test:

### 1. Storage Bucket Oluşturun:

- **Bucket name**: `avatars`
- **Public**: ✅
- **Create bucket**

### 2. Policies Ekleyin:

- SQL Editor'da yukarıdaki komutları çalıştırın

### 3. Flutter App'te Test:

- Profil sayfasından fotoğraf seçin
- Kaydedin

### 4. Kontrol:

- Storage'da dosya var mı?
- Public URL çalışıyor mu?

## 📱 Beklenen Sonuç:

- ✅ Profil fotoğrafı yüklenir
- ✅ Ana sayfada görünür
- ✅ Sidebar'da görünür
- ✅ Profil sayfasında görünür
- ❌ Hata durumunda: İsim baş harfleri görünür
