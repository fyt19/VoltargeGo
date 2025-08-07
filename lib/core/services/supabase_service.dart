import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

class SupabaseService {
  // Supabase projenizden alacağınız bilgiler
  static const String supabaseUrl = 'https://tiiwvaecptaupbhozjsx.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRpaXd2YWVjcHRhdXBiaG96anN4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQxNTM1MDMsImV4cCI6MjA2OTcyOTUwM30.wsfvK3-cZtN4LqrZlpHh40McKQHYFgkYYYzX_NCJLE8';

  static SupabaseClient get client => Supabase.instance.client;

  // Email doğrulama fonksiyonu
  static bool isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }

  // Auth işlemleri
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
      },
    );
  }

  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      if (e.toString().contains('Invalid login credentials')) {
        throw Exception(
            'Email veya şifre hatalı. Lütfen bilgilerinizi kontrol edin.');
      } else if (e.toString().contains('Email not confirmed')) {
        throw Exception(
            'Email adresiniz henüz onaylanmamış. Lütfen email kutunuzu kontrol edin.');
      } else {
        throw Exception('Giriş yapılırken bir hata oluştu: ${e.toString()}');
      }
    }
  }

  static Future<void> signOut() async {
    await client.auth.signOut();
  }

  // Kullanıcı bilgilerini al
  static User? getCurrentUser() {
    return client.auth.currentUser;
  }

  // Charging Stations
  static Future<List<Map<String, dynamic>>> getChargingStations() async {
    final response =
        await client.from('charging_stations').select().order('name');
    return List<Map<String, dynamic>>.from(response);
  }

  // Şarj istasyonu detayı
  static Future<Map<String, dynamic>> getChargingStationById(String id) async {
    final response =
        await client.from('charging_stations').select().eq('id', id).single();
    return response;
  }

  // Şarj noktalarını al
  static Future<List<Map<String, dynamic>>> getChargingPoints(
      String stationId) async {
    final response = await client
        .from('charging_points')
        .select()
        .eq('station_id', stationId);
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

  // Kullanıcının rezervasyonlarını al
  static Future<List<Map<String, dynamic>>> getUserReservations() async {
    final user = client.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final response = await client.from('reservations').select('''
          *,
          charging_stations(name, address),
          charging_points(type, power)
        ''').eq('user_id', user.id).order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  // Ödeme oluştur
  static Future<Map<String, dynamic>> createPayment({
    required String reservationId,
    required double amount,
    required String method,
  }) async {
    final response = await client
        .from('payments')
        .insert({
          'reservation_id': reservationId,
          'amount': amount,
          'method': method,
          'status': 'pending',
        })
        .select()
        .single();

    return response;
  }

  // Puanlama ekle
  static Future<Map<String, dynamic>> addRating({
    required String stationId,
    required String reservationId,
    required int rating,
    String? comment,
  }) async {
    final user = client.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final response = await client
        .from('ratings')
        .insert({
          'user_id': user.id,
          'station_id': stationId,
          'reservation_id': reservationId,
          'rating': rating,
          'comment': comment,
        })
        .select()
        .single();

    return response;
  }

  // Şarj istasyonu puanlarını al
  static Future<List<Map<String, dynamic>>> getStationRatings(
      String stationId) async {
    final response = await client.from('ratings').select('''
          *,
          auth.users(first_name, last_name)
        ''').eq('station_id', stationId).order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  // Kullanıcı profilini güncelle
  static Future<void> updateUserProfile({
    required String firstName,
    required String lastName,
    String? phone,
  }) async {
    final user = client.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    // Kullanıcı metadata'sını güncelle
    await client.auth.updateUser(
      UserAttributes(
        data: {
          'first_name': firstName,
          'last_name': lastName,
          'phone': phone,
        },
      ),
    );
  }

  // Kullanıcı profilini al
  static Future<Map<String, dynamic>?> getUserProfile() async {
    final user = client.auth.currentUser;
    if (user == null) return null;

    // Kullanıcı metadata'sını al
    final userData = user.userMetadata ?? {};
    final email = user.email;
    final id = user.id;

    return {
      'id': id,
      'email': email,
      'first_name': userData['first_name'] ?? '',
      'last_name': userData['last_name'] ?? '',
      'phone': userData['phone'] ?? '',
      'points': userData['points'] ?? 0,
      'avatar_url': userData['avatar_url'] ?? '',
      'created_at': user.createdAt?.toString() ?? '',
    };
  }

  // Profil fotoğrafı yükle
  static Future<String> uploadProfileImage(String filePath) async {
    final user = client.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    try {
      print('📁 Dosya yolu: $filePath');

      final fileName =
          'profile_${user.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final file = File(filePath);

      print('📁 Dosya var mı: ${await file.exists()}');
      print('📁 Dosya boyutu: ${await file.length()} bytes');

      // Dosyanın var olduğunu kontrol et
      if (!await file.exists()) {
        throw Exception('Dosya bulunamadı: $filePath');
      }

      print('📤 Storage\'a yükleniyor: $fileName');

      // Storage'a yükle
      await client.storage.from('avatars').upload(fileName, file);

      print('✅ Storage\'a yüklendi');

      // Public URL al
      final imageUrl = client.storage.from('avatars').getPublicUrl(fileName);

      print('🔗 Public URL: $imageUrl');

      // Kullanıcı metadata'sını güncelle
      await client.auth.updateUser(
        UserAttributes(
          data: {
            'avatar_url': imageUrl,
          },
        ),
      );

      print('✅ Metadata güncellendi');
      return imageUrl;
    } catch (e) {
      print('❌ Profil fotoğrafı yükleme hatası: $e');
      throw Exception('Profil fotoğrafı yüklenemedi: $e');
    }
  }

  // Profil bilgilerini güncelle
  static Future<void> updateProfile({
    required String firstName,
    required String lastName,
    String? phone,
    String? avatarUrl,
  }) async {
    final user = client.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    await client.auth.updateUser(
      UserAttributes(
        data: {
          'first_name': firstName,
          'last_name': lastName,
          'phone': phone,
          if (avatarUrl != null) 'avatar_url': avatarUrl,
        },
      ),
    );
  }
}
