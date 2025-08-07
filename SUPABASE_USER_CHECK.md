# 🔍 Supabase Kullanıcı Kontrol Rehberi

## Sorun: "Invalid login credentials"

Bu hata şu durumlardan kaynaklanabilir:

### 1. Supabase Dashboard'da Kullanıcı Kontrolü

1. **Supabase Dashboard**'a gidin
2. **Authentication** > **Users** sekmesine tıklayın
3. Kullanıcı listesinde `aasd123@asd.com` var mı kontrol edin

### 2. Eğer Kullanıcı Yoksa:

**Önce kayıt olun:**

- Email: `aasd123@asd.com`
- Şifre: `123456`
- Ad Soyad: `Test Kullanıcı`

### 3. Eğer Kullanıcı Varsa:

**Kullanıcı durumunu kontrol edin:**

- **Confirmed**: ✅ (Giriş yapabilir)
- **Unconfirmed**: ❌ (Email onayı gerekli)

### 4. Email Onayı Gerekliyse:

**Supabase Dashboard'da:**

1. **Authentication** > **Settings** sekmesine gidin
2. **Email Auth** bölümünde:
   - **Enable email confirmations** seçeneğini **KAPATIN**
   - **Save** butonuna tıklayın

### 5. Test Kullanıcısı Oluşturun:

**Supabase Dashboard'da:**

1. **Authentication** > **Users** sekmesine gidin
2. **Add user** butonuna tıklayın
3. **Email**: `test@example.com`
4. **Password**: `123456`
5. **Add user** butonuna tıklayın

### 6. Flutter App'te Test Edin:

**Kayıt Ol:**

- Email: `test@example.com`
- Şifre: `123456`
- Ad Soyad: `Test Kullanıcı`

**Giriş Yap:**

- Email: `test@example.com`
- Şifre: `123456`

## 🔧 Alternatif Çözüm - Test Kullanıcısı Oluşturma:

Supabase Dashboard'da manuel olarak test kullanıcısı oluşturun:

1. **Authentication** > **Users** > **Add user**
2. **Email**: `test@example.com`
3. **Password**: `123456`
4. **Add user**

Bu kullanıcı ile giriş yapmayı deneyin.
