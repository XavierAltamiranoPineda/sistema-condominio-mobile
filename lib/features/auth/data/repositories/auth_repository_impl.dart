import 'package:dio/dio.dart';
import '../../../../core/storage/local_storage.dart';
import '../../domain/models/auth_response.dart';
import '../../domain/repositories/auth_repository.dart';
import 'dart:convert';

class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio;
  final LocalStorage _localStorage;

  AuthRepositoryImpl(this._dio, this._localStorage);

  @override
  Future<AuthResponse> login(String username, String password) async {
    final response = await _dio.post(
      '/api/auth/login',
      data: {
        'usuario': username,
        'password': password,
      },
    );

    final authResponse = AuthResponse.fromJson(response.data);
    await _localStorage.saveToken(authResponse.token);
    await _localStorage.saveUser(jsonEncode({'usuario': authResponse.usuario, 'idUsuario': authResponse.idUsuario}));
    await _localStorage.saveRoles(authResponse.roles);

    return authResponse;
  }

  @override
  Future<void> logout() async {
    await _localStorage.clearAll();
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = _localStorage.getToken();
    return token != null && token.isNotEmpty;
  }
}
