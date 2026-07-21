import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../../../../core/network/api_client.dart';
import '../../data/repositories/residente_repository_impl.dart';
import '../../domain/repositories/residente_repository.dart';
import '../../domain/models/residente.dart';

final residenteRepositoryProvider = Provider<ResidenteRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ResidenteRepositoryImpl(dio);
});

class ResidentesNotifier extends AsyncNotifier<List<Residente>> {
  late final ResidenteRepository _repository;
  Timer? _syncTimer;

  @override
  Future<List<Residente>> build() async {
    _repository = ref.watch(residenteRepositoryProvider);
    _startSyncTimer();
    return await _repository.getResidentes();
  }

  void _startSyncTimer() {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      fetchResidentes();
    });
  }

  Future<void> fetchResidentes() async {
    final newState = await AsyncValue.guard(() => _repository.getResidentes());
    if (newState.hasError && state.hasValue) return;
    state = newState;
  }
  
  Future<void> addResidente(Residente r) async {
    await _repository.createResidente(r);
    fetchResidentes();
  }
  
  Future<void> editResidente(int id, Residente r) async {
    await _repository.updateResidente(id, r);
    fetchResidentes();
  }
  
  Future<void> toggleEstado(int id, String currentEstado) async {
    final newEstado = currentEstado == 'ACTIVO' ? 'INACTIVO' : 'ACTIVO';
    await _repository.changeState(id, newEstado);
    fetchResidentes();
  }
}

final residentesListProvider = AsyncNotifierProvider<ResidentesNotifier, List<Residente>>(() {
  return ResidentesNotifier();
});
