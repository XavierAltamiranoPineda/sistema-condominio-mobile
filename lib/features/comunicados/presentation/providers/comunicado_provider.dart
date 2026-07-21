import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../../../../core/network/api_client.dart';
import '../../data/repositories/comunicado_repository_impl.dart';
import '../../domain/repositories/comunicado_repository.dart';
import '../../domain/models/comunicado.dart';

final comunicadoRepositoryProvider = Provider<ComunicadoRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ComunicadoRepositoryImpl(dio);
});

class ComunicadosNotifier extends AsyncNotifier<List<Comunicado>> {
  late final ComunicadoRepository _repository;
  Timer? _syncTimer;

  @override
  Future<List<Comunicado>> build() async {
    _repository = ref.watch(comunicadoRepositoryProvider);
    _startSyncTimer();
    return await _repository.getComunicados();
  }

  void _startSyncTimer() {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      fetchComunicados();
    });
  }

  Future<void> fetchComunicados() async {
    final newState = await AsyncValue.guard(() => _repository.getComunicados());
    if (newState.hasError && state.hasValue) return;
    state = newState;
  }

  Future<void> marcarLeido(int id) async {
    await _repository.marcarLeido(id);
    fetchComunicados();
  }
}

final comunicadosListProvider = AsyncNotifierProvider<ComunicadosNotifier, List<Comunicado>>(() {
  return ComunicadosNotifier();
});
