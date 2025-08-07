import 'package:dio/dio.dart';
import '../../core/network/api_service.dart';
import '../models/user_model.dart';

class AuthRepository {
  final ApiService _apiService = ApiService();

  // Login
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _apiService.login(email, password);

      if (response.statusCode == 200) {
        final user = UserModel.fromJson(response.data['user']);
        return {
          'success': true,
          'user': user,
          'token': response.data['token'],
          'message': 'Giriş başarılı',
        };
      } else {
        return {
          'success': false,
          'message': 'Giriş başarısız',
        };
      }
    } on DioException catch (e) {
      String message = 'Bir hata oluştu';

      if (e.response?.statusCode == 401) {
        message = 'E-posta veya şifre hatalı';
      } else if (e.response?.statusCode == 404) {
        message = 'Kullanıcı bulunamadı';
      } else if (e.type == DioExceptionType.connectionTimeout) {
        message = 'Bağlantı zaman aşımı';
      } else if (e.type == DioExceptionType.connectionError) {
        message = 'Bağlantı hatası';
      }

      return {
        'success': false,
        'message': message,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Beklenmeyen bir hata oluştu',
      };
    }
  }

  // Register
  Future<Map<String, dynamic>> register(
      String name, String email, String password) async {
    try {
      final response = await _apiService.register(name, email, password);

      if (response.statusCode == 201) {
        final user = UserModel.fromJson(response.data['user']);
        return {
          'success': true,
          'user': user,
          'token': response.data['token'],
          'message': 'Kayıt başarılı',
        };
      } else {
        return {
          'success': false,
          'message': 'Kayıt başarısız',
        };
      }
    } on DioException catch (e) {
      String message = 'Bir hata oluştu';

      if (e.response?.statusCode == 409) {
        message = 'Bu e-posta adresi zaten kullanımda';
      } else if (e.response?.statusCode == 400) {
        message = 'Geçersiz bilgiler';
      } else if (e.type == DioExceptionType.connectionTimeout) {
        message = 'Bağlantı zaman aşımı';
      } else if (e.type == DioExceptionType.connectionError) {
        message = 'Bağlantı hatası';
      }

      return {
        'success': false,
        'message': message,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Beklenmeyen bir hata oluştu',
      };
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _apiService.logout();
    } catch (e) {
      // Hata olsa bile local temizlik yap
    }
  }

  // Forgot Password
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      final response = await _apiService.forgotPassword(email);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Şifre sıfırlama bağlantısı e-posta adresinize gönderildi',
        };
      } else {
        return {
          'success': false,
          'message': 'Şifre sıfırlama başarısız',
        };
      }
    } on DioException catch (e) {
      String message = 'Bir hata oluştu';

      if (e.response?.statusCode == 404) {
        message = 'Bu e-posta adresi bulunamadı';
      } else if (e.type == DioExceptionType.connectionTimeout) {
        message = 'Bağlantı zaman aşımı';
      } else if (e.type == DioExceptionType.connectionError) {
        message = 'Bağlantı hatası';
      }

      return {
        'success': false,
        'message': message,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Beklenmeyen bir hata oluştu',
      };
    }
  }

  // Get User Profile
  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final response = await _apiService.getUserProfile();

      if (response.statusCode == 200) {
        final user = UserModel.fromJson(response.data);
        return {
          'success': true,
          'user': user,
        };
      } else {
        return {
          'success': false,
          'message': 'Profil bilgileri alınamadı',
        };
      }
    } on DioException catch (e) {
      String message = 'Bir hata oluştu';

      if (e.response?.statusCode == 401) {
        message = 'Oturum süresi dolmuş';
      } else if (e.type == DioExceptionType.connectionTimeout) {
        message = 'Bağlantı zaman aşımı';
      } else if (e.type == DioExceptionType.connectionError) {
        message = 'Bağlantı hatası';
      }

      return {
        'success': false,
        'message': message,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Beklenmeyen bir hata oluştu',
      };
    }
  }

  // Update User Profile
  Future<Map<String, dynamic>> updateUserProfile(
      Map<String, dynamic> profileData) async {
    try {
      final response = await _apiService.updateUserProfile(profileData);

      if (response.statusCode == 200) {
        final user = UserModel.fromJson(response.data);
        return {
          'success': true,
          'user': user,
          'message': 'Profil güncellendi',
        };
      } else {
        return {
          'success': false,
          'message': 'Profil güncellenemedi',
        };
      }
    } on DioException catch (e) {
      String message = 'Bir hata oluştu';

      if (e.response?.statusCode == 400) {
        message = 'Geçersiz bilgiler';
      } else if (e.response?.statusCode == 401) {
        message = 'Oturum süresi dolmuş';
      } else if (e.type == DioExceptionType.connectionTimeout) {
        message = 'Bağlantı zaman aşımı';
      } else if (e.type == DioExceptionType.connectionError) {
        message = 'Bağlantı hatası';
      }

      return {
        'success': false,
        'message': message,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Beklenmeyen bir hata oluştu',
      };
    }
  }
}
