import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/storage/providers.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final localStorage = ref.watch(localStorageProvider);
  return AuthRepositoryImpl(dio, localStorage);
});

class AuthNotifier extends AsyncNotifier<bool> {
  late final AuthRepository _repository;

  @override
  Future<bool> build() async {
    _repository = ref.watch(authRepositoryProvider);
    return await _repository.isAuthenticated();
  }

  Future<void> login(String username, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.login(username, password);
      return true;
    });
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.logout();
      return false;
    });
  }
}

final authStateProvider = AsyncNotifierProvider<AuthNotifier, bool>(() {
  return AuthNotifier();
});
