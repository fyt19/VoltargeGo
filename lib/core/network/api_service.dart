import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  // Backend URL'leri - voltargego.duyari.com.tr domain'i
  static const String _localUrl =
      'http://10.0.2.2:5140/api'; // Android emülatör
  static const String _productionUrl =
      'https://voltargego.duyari.com.tr/api'; // Production URL

  // Sunucuya direkt bağlanıyoruz
  static const String _baseUrl = _productionUrl;

  late final Dio _dio;

  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Token varsa ekle
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('auth_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        // 401 hatası durumunda token'ı temizle
        if (error.response?.statusCode == 401) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove('auth_token');
          await prefs.remove('is_logged_in');
        }
        handler.next(error);
      },
    ));
  }

  // ==================== AUTH ENDPOINTS ====================

  // Login
  Future<Response> login(String email, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      // Token'ı kaydet
      if (response.data['token'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', response.data['token']);
        await prefs.setBool('is_logged_in', true);
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Register
  Future<Response> register(String name, String email, String password) async {
    try {
      final response = await _dio.post('/auth/register', data: {
        'firstName': name.split(' ').first,
        'lastName': name.split(' ').length > 1
            ? name.split(' ').sublist(1).join(' ')
            : '',
        'email': email,
        'password': password,
      });

      // Token'ı kaydet
      if (response.data['token'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', response.data['token']);
        await prefs.setBool('is_logged_in', true);
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _dio.post('/auth/logout');
    } catch (e) {
      // Hata olsa bile local token'ı temizle
    } finally {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('is_logged_in');
    }
  }

  // Password Reset
  Future<Response> forgotPassword(String email) async {
    return _dio.post('/auth/forgot-password', data: {
      'email': email,
    });
  }

  // ==================== USER PROFILE ENDPOINTS ====================

  // Kullanıcı profilini getir
  Future<Response> getUserProfile() async {
    return _dio.get('/user/profile');
  }

  // Kullanıcı profilini güncelle
  Future<Response> updateUserProfile(Map<String, dynamic> profileData) async {
    return _dio.put('/user/profile', data: profileData);
  }

  // Kullanıcı istatistiklerini getir
  Future<Response> getUserStats() async {
    return _dio.get('/user/stats');
  }

  // ==================== CHARGING STATIONS ENDPOINTS ====================

  // Şarj istasyonlarını listele
  Future<Response> getStations({
    double? latitude,
    double? longitude,
    double? radius,
    String? search,
    List<String>? filters,
  }) async {
    final queryParams = <String, dynamic>{};
    if (latitude != null) queryParams['lat'] = latitude;
    if (longitude != null) queryParams['lng'] = longitude;
    if (radius != null) queryParams['radius'] = radius;
    if (search != null) queryParams['search'] = search;
    if (filters != null) queryParams['filters'] = filters.join(',');

    return _dio.get('/charging-stations', queryParameters: queryParams);
  }

  // Şarj istasyonu detayını getir
  Future<Response> getStationDetail(String stationId) async {
    return _dio.get('/charging-stations/$stationId');
  }

  // Şarj istasyonu yorumlarını getir
  Future<Response> getStationReviews(String stationId, {int page = 1}) async {
    return _dio.get('/charging-stations/$stationId/reviews',
        queryParameters: {'page': page});
  }

  // Şarj istasyonuna yorum ekle
  Future<Response> addStationReview(
    String stationId, {
    required double rating,
    required String comment,
  }) async {
    return _dio.post('/charging-stations/$stationId/reviews', data: {
      'rating': rating,
      'comment': comment,
    });
  }

  // ==================== RESERVATIONS ENDPOINTS ====================

  // Rezervasyon oluştur
  Future<Response> createReservation(
      Map<String, dynamic> reservationData) async {
    return _dio.post('/reservations', data: reservationData);
  }

  // Kullanıcının rezervasyonlarını getir
  Future<Response> getUserReservations({String? status}) async {
    final queryParams = status != null ? {'status': status} : null;
    return _dio.get('/reservations', queryParameters: queryParams);
  }

  // Rezervasyon detayını getir
  Future<Response> getReservationDetail(String reservationId) async {
    return _dio.get('/reservations/$reservationId');
  }

  // Rezervasyonu iptal et
  Future<Response> cancelReservation(String reservationId) async {
    return _dio.put('/reservations/$reservationId/cancel');
  }

  // ==================== PAYMENT ENDPOINTS ====================

  // Ödeme yöntemlerini getir
  Future<Response> getPaymentMethods() async {
    return _dio.get('/payment/methods');
  }

  // Ödeme yöntemi ekle
  Future<Response> addPaymentMethod(Map<String, dynamic> paymentData) async {
    return _dio.post('/payment/methods', data: paymentData);
  }

  // Ödeme yöntemini sil
  Future<Response> deletePaymentMethod(String methodId) async {
    return _dio.delete('/payment/methods/$methodId');
  }

  // Ödeme yap
  Future<Response> processPayment(Map<String, dynamic> paymentData) async {
    return _dio.post('/payment/process', data: paymentData);
  }

  // ==================== RENTAL HISTORY ENDPOINTS ====================

  // Kiralama geçmişini getir
  Future<Response> getRentalHistory({int page = 1}) async {
    return _dio.get('/rentals/history', queryParameters: {'page': page});
  }

  // Kiralama detayını getir
  Future<Response> getRentalDetail(String rentalId) async {
    return _dio.get('/rentals/$rentalId');
  }

  // ==================== RATINGS & REVIEWS ENDPOINTS ====================

  // Kullanıcının verdiği puanları getir
  Future<Response> getUserRatings({int page = 1}) async {
    return _dio.get('/ratings/user', queryParameters: {'page': page});
  }

  // Puan ver
  Future<Response> addRating(Map<String, dynamic> ratingData) async {
    return _dio.post('/ratings', data: ratingData);
  }

  // ==================== NOTIFICATIONS ENDPOINTS ====================

  // Bildirimleri getir
  Future<Response> getNotifications({int page = 1}) async {
    return _dio.get('/notifications', queryParameters: {'page': page});
  }

  // Bildirimi okundu olarak işaretle
  Future<Response> markNotificationAsRead(String notificationId) async {
    return _dio.put('/notifications/$notificationId/read');
  }

  // ==================== UTILITY METHODS ====================

  // Token ayarlama (manuel)
  void setToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  // Base URL'i değiştirme (production'a geçerken)
  void setBaseUrl(String url) {
    _dio.options.baseUrl = url;
  }

  // Production'a geçiş
  void switchToProduction() {
    _dio.options.baseUrl = _productionUrl;
  }

  // Local'e geçiş
  void switchToLocal() {
    _dio.options.baseUrl = _localUrl;
  }
}
