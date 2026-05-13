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
      '/api/v1/login',
      data: {'email': email, 'password': password},
    );
  }

  Future<Response> register(
      String name, String email, String password) async {
    return await _dio.post(
      '/api/v1/register',
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
      '/api/v1/me', // NOTE: Endpoint guessed based on common practice, please confirm from docs if it's different.
    );
  }

  Future<Response> updateProfile(String id, Map<String, dynamic> data) async {
    return await _dio.put(
      '/api/v1/profile/$id', // Placeholder endpoint
      data: data,
    );
  }

  Future<Response> getOrders() async {
    return await _dio.get('/api/v1/ecommerce/orders');
  }

  Future<Response> getLoyaltySummary() async {
    return await _dio.get('/api/v1/loyalty/summary');
  }

  Future<Response> getFlashSales() async {
    return await _dio.get('/api/v1/ecommerce/flash-sales');
  }
}

final suitProServiceProvider = Provider<SuitProService>((ref) {
  final dio = Dio(BaseOptions(baseUrl: 'https://suitprolondon.com'));

  // Add an interceptor to include the auth token in all requests
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      if (_suitProToken != null) {
        options.headers['Authorization'] = 'Bearer $_suitProToken';
      }
      return handler.next(options);
    },
  ));

  return SuitProService(dio);
});
