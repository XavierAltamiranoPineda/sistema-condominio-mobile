import 'package:dio/dio.dart';
import '../../domain/models/dashboard_stats.dart';
import '../../domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final Dio _dio;

  DashboardRepositoryImpl(this._dio);

  @override
  Future<ReporteGeneral> getStats() async {
    final response = await _dio.get('/api/reportes/general');
    return ReporteGeneral.fromJson(response.data);
  }
}
