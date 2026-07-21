import 'package:dio/dio.dart';
import '../../domain/models/residente.dart';
import '../../domain/repositories/residente_repository.dart';

class ResidenteRepositoryImpl implements ResidenteRepository {
  final Dio _dio;

  ResidenteRepositoryImpl(this._dio);

  @override
  Future<List<Residente>> getResidentes() async {
    final response = await _dio.get('/api/residentes');
    return (response.data as List).map((e) => Residente.fromJson(e)).toList();
  }

  @override
  Future<Residente> createResidente(Residente residente) async {
    final response = await _dio.post('/api/residentes', data: residente.toJson());
    return Residente.fromJson(response.data);
  }

  @override
  Future<Residente> updateResidente(int id, Residente residente) async {
    final response = await _dio.put('/api/residentes/$id', data: residente.toJson());
    return Residente.fromJson(response.data);
  }

  @override
  Future<void> changeState(int id, String estado) async {
    // Some backend APIs use PATCH for states. If it fails, error interceptor will throw.
    await _dio.patch('/api/residentes/$id/estado', queryParameters: {'estado': estado});
  }
}
