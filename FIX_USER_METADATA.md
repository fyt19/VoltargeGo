# 🔧 Kullanıcı Metadata Düzeltme

## Sorun: Kullanıcı bilgileri uygulamada görünmüyor

### 1. Supabase Dashboard'da Manuel Düzeltme:

#### Adım 1: Kullanıcıya Gidin

1. **Supabase Dashboard** > **Authentication** > **Users**
2. Kayıt olduğunuz kullanıcıya tıklayın

#### Adım 2: Edit Butonuna Tıklayın

1. **Edit** butonuna tıklayın
2. **User metadata** alanını bulun

#### Adım 3: Metadata Ekleyin

**User metadata** alanına şunu ekleyin:

```json
{
  "first_name": "Test",
  "last_name": "Kullanıcı",
  "phone": "",
  "points": 0,
  "avatar_url": ""
}
```

#### Adım 4: Kaydedin

1. **Save** butonuna tıklayın
2. Flutter app'i yeniden başlatın

### 2. Flutter App'te Test Edin:

1. **Çıkış yapın**
2. **Tekrar giriş yapın**
3. Artık ad-soyad görünmeli

## 🔧 Çözüm 2: Supabase Service'i Düzeltme

### Sorun: Kayıt olurken metadata düzgün kaydedilmiyor

### Düzeltme: Supabase Service'te signUp metodunu güncelleyin

```dart
static Future<AuthResponse> signUp({
  required String email,
  required String password,
  required String firstName,
  required String lastName,
}) async {
  // Email formatını kontrol et
  if (!isValidEmail(email)) {
    throw Exception(
        'Geçersiz email formatı. Lütfen geçerli bir email adresi girin.');
  }

  return await client.auth.signUp(
    email: email,
    password: password,
    data: {
      'first_name': firstName,
      'last_name': lastName,
      'phone': '',
      'points': 0,
      'avatar_url': '',
    },
  );
}
```

## 🔧 Çözüm 3: Yeni Test Kullanıcısı Oluşturma

### Adım 1: Supabase Dashboard'da

1. **Authentication** > **Users** > **Add user**
2. **Email**: `test2@example.com`
3. **Password**: `123456`
4. **Add user**

### Adım 2: Metadata Ekleyin

1. Kullanıcıya tıklayın
2. **Edit** butonuna tıklayın
3. **User metadata** alanına:

```json
{
  "first_name": "Test",
  "last_name": "Kullanıcı",
  "phone": "",
  "points": 0,
  "avatar_url": ""
}
```

### Adım 3: Flutter App'te Test

1. **Giriş yapın**:
   - Email: `test2@example.com`
   - Şifre: `123456`
2. Ad-soyad görünmeli

## 🔧 Çözüm 4: Register Sayfasını Düzeltme

### Sorun: Kayıt olurken metadata düzgün gönderilmiyor

### Düzeltme: Register sayfasında metadata güncelleme

```dart
// Kayıt olduktan sonra metadata güncelle
if (response.user != null) {
  // Kullanıcı metadata'sını güncelle
  await client.auth.updateUser(
    UserAttributes(
      data: {
        'first_name': firstName,
        'last_name': lastName,
        'phone': '',
        'points': 0,
        'avatar_url': '',
      },
    ),
  );
}
```

## 🎯 Hızlı Test:

### 1. Mevcut Kullanıcıyı Düzeltin:

1. **Supabase Dashboard** > **Authentication** > **Users**
2. Kullanıcınıza tıklayın
3. **Edit** butonuna tıklayın
4. **User metadata** alanına şunu ekleyin:

```json
{
  "first_name": "Test",
  "last_name": "Kullanıcı",
  "phone": "",
  "points": 0,
  "avatar_url": ""
}
```

5. **Save** butonuna tıklayın

### 2. Flutter App'te Test:

1. **Çıkış yapın**
2. **Tekrar giriş yapın**
3. Artık ad-soyad görünmeli

## 📱 Beklenen Sonuç:

- ✅ Ana sayfada: "Test Kullanıcı" görünmeli
- ✅ Sidebar'da: "Test Kullanıcı" görünmeli
- ✅ Profil sayfasında: "Test Kullanıcı" görünmeli
- ✅ Profil fotoğrafı yoksa: "TK" harfleri görünmeli
