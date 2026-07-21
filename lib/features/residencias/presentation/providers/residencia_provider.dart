import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../../../../core/network/api_client.dart';
import '../../data/repositories/residencia_repository_impl.dart';
import '../../domain/repositories/residencia_repository.dart';
import '../../domain/models/residencia.dart';

final residenciaRepositoryProvider = Provider<ResidenciaRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ResidenciaRepositoryImpl(dio);
});

class ResidenciasNotifier extends AsyncNotifier<List<Residencia>> {
  late final ResidenciaRepository _repository;
  Timer? _syncTimer;

  @override
  Future<List<Residencia>> build() async {
    _repository = ref.watch(residenciaRepositoryProvider);
    _startSyncTimer();
    return await _repository.getResidencias();
  }

  void _startSyncTimer() {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      fetchResidencias();
    });
  }

  Future<void> fetchResidencias() async {
    final newState = await AsyncValue.guard(() => _repository.getResidencias());
    if (newState.hasError && state.hasValue) return;
    state = newState;
  }

  Future<void> addResidencia(Residencia r) async {
    await _repository.createResidencia(r);
    fetchResidencias();
  }

  Future<void> editResidencia(int id, Residencia r) async {
    await _repository.updateResidencia(id, r);
    fetchResidencias();
  }

  Future<void> toggleEstado(int id, String currentEstado) async {
    final newEstado = currentEstado == 'ACTIVO' ? 'INACTIVO' : 'ACTIVO';
    await _repository.changeState(id, newEstado);
    fetchResidencias();
  }
}

final residenciasListProvider = AsyncNotifierProvider<ResidenciasNotifier, List<Residencia>>(() {
  return ResidenciasNotifier();
});
