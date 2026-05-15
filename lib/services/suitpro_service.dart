import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// This is a simple token manager. In a real app, you might use secure storage.
String? _suitProToken;

void setSuitProToken(String? token) {
  _suitProToken = token;
}

class SuitProService {
  final Dio _dio;

  SuitProService(this._dio);

  Future<Response> login(String email, String password) async {
    return await _dio.post(
      'login',
      data: {'email': email, 'password': password},
    );
  }

  Future<Response> register(
      String name, String email, String password) async {
    return await _dio.post(
      'register',
      data: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password,
      },
    );
  }

  Future<Response> getMe() async {
    return await _dio.get(
      'me',
    );
  }

  Future<Response> updateProfile(String id, Map<String, dynamic> data) async {
    return await _dio.put(
      'profile/$id',
      data: data,
    );
  }

  Future<Response> getOrders() async {
    return await _dio.get('ecommerce/orders');
  }

  Future<Response> getLoyaltySummary() async {
    return await _dio.get('loyalty/summary');
  }

  Future<Response> getFlashSales() async {
    return await _dio.get('ecommerce/flash-sales');
  }
}

final suitProServiceProvider = Provider<SuitProService>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://suitprolondon.com/api/v1/',
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
    },
    validateStatus: (status) {
      return status != null && status < 500;
    },
  ));

  // Add an interceptor to include the auth token in all requests
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      // Don't send token for login or register endpoints
      final bool isAuthPath = options.path.contains('login') || options.path.contains('register');
      
      if (_suitProToken != null && !isAuthPath) {
        options.headers['Authorization'] = 'Bearer $_suitProToken';
      }
      return handler.next(options);
    },
  ));

  return SuitProService(dio);
});
