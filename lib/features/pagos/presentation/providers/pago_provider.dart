import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../../../../core/network/api_client.dart';
import '../../data/repositories/pago_repository_impl.dart';
import '../../domain/repositories/pago_repository.dart';
import '../../domain/models/pago.dart';

final pagoRepositoryProvider = Provider<PagoRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return PagoRepositoryImpl(dio);
});

class PagosNotifier extends AsyncNotifier<List<Pago>> {
  late final PagoRepository _repository;
  Timer? _syncTimer;

  @override
  Future<List<Pago>> build() async {
    _repository = ref.watch(pagoRepositoryProvider);
    _startSyncTimer();
    return await _repository.getPagos();
  }

  void _startSyncTimer() {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      fetchPagos();
    });
  }

  Future<void> fetchPagos() async {
    final newState = await AsyncValue.guard(() => _repository.getPagos());
    if (newState.hasError && state.hasValue) return;
    state = newState;
  }

  Future<void> registrarPago(Pago p) async {
    await _repository.registrarPago(p);
    fetchPagos();
  }

  Future<double> consultarDeuda(int residenteId) async {
    return await _repository.consultarDeuda(residenteId);
  }
}

final pagosListProvider = AsyncNotifierProvider<PagosNotifier, List<Pago>>(() {
  return PagosNotifier();
});
