# 🔧 Supabase Email Doğrulama Sorunu Çözümü

## Sorun:

`AuthApiException(message: Email address 'asd@gmail.com' is invalid, statusCode: 400, code: email_address_invalid)`

## Çözüm Adımları:

### 1. Supabase Dashboard'da Email Doğrulama Ayarlarını Kontrol Edin:

1. **Supabase Dashboard**'a gidin
2. **Authentication** > **Settings** sekmesine gidin
3. **Email Auth** bölümünü bulun
4. **Enable email confirmations** seçeneğini **KAPATIN** (geçici olarak)
5. **Save** butonuna tıklayın

### 2. Email Formatını Daha Sıkı Kontrol Edelim:

Flutter app'te email formatını daha sıkı doğrulayalım:

```dart
// Email doğrulama fonksiyonu
bool isValidEmail(String email) {
  return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
      .hasMatch(email);
}
```

### 3. Test Email'leri:

Geçerli test email'leri:

- `test@example.com`
- `user@gmail.com`
- `admin@voltargego.com`
- `info@test.org`

### 4. Supabase Service'te Email Doğrulama Ekleyelim:

```dart
static Future<AuthResponse> signUp({
  required String email,
  required String password,
  required String firstName,
  required String lastName,
}) async {
  // Email formatını kontrol et
  if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
      .hasMatch(email)) {
    throw Exception('Geçersiz email formatı');
  }

  return await client.auth.signUp(
    email: email,
    password: password,
    data: {
      'first_name': firstName,
      'last_name': lastName,
    },
  );
}
```

### 5. Alternatif Çözüm - Test Modu:

Supabase projenizi **test modunda** çalıştırmak için:

1. **Settings** > **General** sekmesine gidin
2. **Project Status** bölümünde **Development** seçin
3. Bu modda email doğrulama daha esnek olur

## 🎯 Hızlı Test:

Şu email'lerle test edin:

- ✅ `test@example.com`
- ✅ `user@gmail.com`
- ❌ `asd@gmail.com` (çok kısa)
- ❌ `a@b.c` (çok kısa domain)
