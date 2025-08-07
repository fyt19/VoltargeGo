# 🧪 Test Kullanıcısı Oluşturma

## Hızlı Test İçin:

### 1. Supabase Dashboard'da Manuel Kullanıcı Oluşturun:

1. **Supabase Dashboard**'a gidin
2. **Authentication** > **Users** sekmesine tıklayın
3. **Add user** butonuna tıklayın
4. Şu bilgileri girin:
   - **Email**: `test@example.com`
   - **Password**: `123456`
5. **Add user** butonuna tıklayın

### 2. Email Onayını Kapatın:

1. **Authentication** > **Settings** sekmesine gidin
2. **Email Auth** bölümünde:
   - **Enable email confirmations** seçeneğini **KAPATIN**
   - **Save** butonuna tıklayın

### 3. Flutter App'te Test Edin:

**Giriş Yap:**

- Email: `test@example.com`
- Şifre: `123456`

## Alternatif - Yeni Kullanıcı Kaydı:

### 1. Flutter App'te Kayıt Ol:

1. **Kayıt Ol** sayfasına gidin
2. Şu bilgileri girin:
   - **Ad Soyad**: `Test Kullanıcı`
   - **Email**: `newtest@example.com`
   - **Şifre**: `123456`
   - **Şifre Tekrar**: `123456`
   - **KVKK** kutusunu işaretleyin
3. **Kayıt Ol** butonuna tıklayın

### 2. Giriş Yap:

1. **Giriş Yap** sayfasına gidin
2. Şu bilgileri girin:
   - **Email**: `newtest@example.com`
   - **Şifre**: `123456`
3. **Giriş Yap** butonuna tıklayın

## 🔧 Sorun Giderme:

### Eğer Hala Hata Alıyorsanız:

1. **Supabase Dashboard**'da **Authentication** > **Users** sekmesine gidin
2. Kullanıcının **Confirmed** durumunda olduğunu kontrol edin
3. **Last sign in** tarihini kontrol edin

### Debug İçin:

Flutter app'te console'da şu bilgileri kontrol edin:

- Supabase bağlantı durumu
- Kullanıcı ID'si
- Hata detayları
