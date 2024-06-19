import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/router.dart';

class Api {
  final dio = createDio();

  Api._internal();

  static final Api _instance = Api._internal();

  factory Api() => _instance;

  static Dio createDio() {
    var dio = Dio(
      BaseOptions(
        baseUrl: dotenv.env['API_ADDRESS']!,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
      ),
    );

    dio.interceptors.add(AppInterceptors());

    return dio;
  }
}

class AppInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await secureStorage.read(key: 'jwt');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 || err.response?.statusCode == 403) {
      await AuthProvider().logout();
      router.go('/');
      handler.reject(err);
    }
    handler.next(err);
  }
}