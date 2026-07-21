import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../../../../core/network/api_client.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../domain/models/dashboard_stats.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return DashboardRepositoryImpl(dio);
});

class DashboardStatsNotifier extends AsyncNotifier<ReporteGeneral> {
  late final DashboardRepository _repository;
  Timer? _syncTimer;

  @override
  Future<ReporteGeneral> build() async {
    _repository = ref.watch(dashboardRepositoryProvider);
    _startSyncTimer();
    return await _repository.getStats();
  }

  void _startSyncTimer() {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      fetchStats();
    });
  }

  Future<void> fetchStats() async {
    final newState = await AsyncValue.guard(() => _repository.getStats());
    if (newState.hasError && state.hasValue) {
      return;
    }
    state = newState;
  }
}

final dashboardStatsProvider = AsyncNotifierProvider<DashboardStatsNotifier, ReporteGeneral>(() {
  return DashboardStatsNotifier();
});
