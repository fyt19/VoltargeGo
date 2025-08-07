# 👥 Supabase Kullanıcı Yönetimi

## 1. Kullanıcıları Görme

### Adım 1: Authentication > Users

1. **Supabase Dashboard**'a gidin
2. Sol menüden **Authentication** sekmesine tıklayın
3. **Users** sekmesine tıklayın

### Adım 2: Kullanıcı Listesi

Burada tüm kayıtlı kullanıcılarınızı göreceksiniz:

| Sütun            | Açıklama                  |
| ---------------- | ------------------------- |
| **Email**        | Kullanıcının email adresi |
| **ID**           | Benzersiz kullanıcı ID'si |
| **Created**      | Kayıt tarihi              |
| **Last Sign In** | Son giriş tarihi          |
| **Confirmed**    | Email onay durumu         |
| **Actions**      | İşlemler (Edit, Delete)   |

## 2. Kullanıcı Detaylarını Görme

### Kullanıcıya Tıklayın:

- Kullanıcının detaylı bilgilerini göreceksiniz
- **User ID**: Benzersiz tanımlayıcı
- **Email**: Kullanıcı email'i
- **Created at**: Oluşturulma tarihi
- **Last sign in**: Son giriş tarihi
- **Raw user meta data**: Ek bilgiler (ad, soyad, telefon, vb.)

## 3. Kullanıcı Bilgilerini Düzenleme

### Adım 1: Kullanıcıya Tıklayın

### Adım 2: "Edit" Butonuna Tıklayın

### Adım 3: Bilgileri Güncelleyin:

- **Email**: Email adresini değiştirin
- **Password**: Şifreyi değiştirin
- **User metadata**: JSON formatında ek bilgiler

### Örnek User Metadata:

```json
{
  "first_name": "Test",
  "last_name": "Kullanıcı",
  "phone": "+90 555 123 4567",
  "points": 100,
  "avatar_url": "https://..."
}
```

## 4. Yeni Kullanıcı Ekleme

### Adım 1: "Add user" Butonuna Tıklayın

### Adım 2: Bilgileri Girin:

- **Email**: Kullanıcı email'i
- **Password**: Şifre

### Adım 3: "Add user" Butonuna Tıklayın

## 5. Kullanıcı Silme

### Adım 1: Kullanıcıya Tıklayın

### Adım 2: "Delete" Butonuna Tıklayın

### Adım 3: Onaylayın

## 6. Kullanıcı Durumları

### Confirmed ✅

- Email onaylanmış
- Giriş yapabilir

### Unconfirmed ❌

- Email onaylanmamış
- Giriş yapamaz (email onayı gerekli)

## 7. Kullanıcı İstatistikleri

### Dashboard'da Görebileceğiniz:

- **Toplam kullanıcı sayısı**
- **Bu ay kayıt olan kullanıcılar**
- **Aktif kullanıcılar**
- **Email onayı bekleyen kullanıcılar**

## 8. Kullanıcı Arama ve Filtreleme

### Arama:

- Email adresine göre arama yapabilirsiniz
- Kullanıcı ID'sine göre arama yapabilirsiniz

### Filtreleme:

- **Confirmed** kullanıcıları göster
- **Unconfirmed** kullanıcıları göster
- Tarih aralığına göre filtrele

## 9. Kullanıcı Verilerini Export Etme

### CSV Export:

1. **Users** sayfasında **Export** butonuna tıklayın
2. CSV dosyası indirilecek
3. Excel veya Google Sheets'te açabilirsiniz

## 10. Kullanıcı Aktivite Logları

### Logs Sekmesi:

1. **Authentication** > **Logs** sekmesine gidin
2. Kullanıcı aktivitelerini göreceksiniz:
   - Giriş yapma
   - Kayıt olma
   - Şifre sıfırlama
   - Email onayı

## 🔧 Örnek Kullanıcı Yönetimi

### Test Kullanıcısı Oluşturma:

1. **Add user** butonuna tıklayın
2. **Email**: `admin@voltargego.com`
3. **Password**: `admin123`
4. **Add user** butonuna tıklayın

### Kullanıcı Bilgilerini Güncelleme:

1. Kullanıcıya tıklayın
2. **Edit** butonuna tıklayın
3. **User metadata** alanına şunu ekleyin:

```json
{
  "first_name": "Admin",
  "last_name": "User",
  "phone": "+90 555 000 0000",
  "points": 1000,
  "role": "admin"
}
```

## 📊 Kullanıcı İstatistikleri

### Dashboard'da Görebileceğiniz:

- **Toplam kullanıcı**: 25
- **Bu ay yeni kullanıcı**: 8
- **Aktif kullanıcılar**: 15
- **Email onayı bekleyen**: 2

## 🎯 Önemli Notlar

1. **Kullanıcı ID'si**: Her kullanıcının benzersiz ID'si vardır
2. **Email onayı**: Güvenlik için önemlidir
3. **User metadata**: JSON formatında ek bilgiler saklanır
4. **Silme işlemi**: Geri alınamaz, dikkatli olun
5. **Şifre değiştirme**: Kullanıcıya bildirim gönderilir
