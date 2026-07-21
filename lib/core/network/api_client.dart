import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/constants.dart';
import '../storage/providers.dart';
import 'package:flutter/foundation.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

final dioProvider = Provider<Dio>((ref) {
  final localStorage = ref.watch(localStorageProvider);
  
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = localStorage.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) {
        String customMessage = 'Error de conexión';
        
        if (e.response != null) {
          switch (e.response!.statusCode) {
            case 400:
              customMessage = e.response?.data['mensaje'] ?? 'Error de validación';
              break;
            case 401:
              customMessage = 'Sesión expirada. Vuelve a iniciar sesión.';
              localStorage.clearAll();
              Future.microtask(() {
                try {
                  ref.read(authStateProvider.notifier).logout();
                } catch (_) {}
              });
              break;
            case 403:
              customMessage = 'No tienes permisos para realizar esta acción.';
              break;
            case 500:
              customMessage = 'Error temporal del servidor';
              break;
            default:
              customMessage = 'Error inesperado del servidor: ${e.response?.statusCode}';
          }
        }

        final newError = e.copyWith(error: customMessage);
        return handler.next(newError);
      },
    ),
  );

  if (kDebugMode) {
    dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
  }

  return dio;
});
