import 'package:dio/dio.dart';
import '../../domain/models/residencia.dart';
import '../../domain/repositories/residencia_repository.dart';

class ResidenciaRepositoryImpl implements ResidenciaRepository {
  final Dio _dio;

  ResidenciaRepositoryImpl(this._dio);

  @override
  Future<List<Residencia>> getResidencias() async {
    final response = await _dio.get('/api/residencias');
    return (response.data as List).map((e) => Residencia.fromJson(e)).toList();
  }

  @override
  Future<Residencia> createResidencia(Residencia residencia) async {
    final response = await _dio.post('/api/residencias', data: residencia.toJson());
    return Residencia.fromJson(response.data);
  }

  @override
  Future<Residencia> updateResidencia(int id, Residencia residencia) async {
    final response = await _dio.put('/api/residencias/$id', data: residencia.toJson());
    return Residencia.fromJson(response.data);
  }

  @override
  Future<void> changeState(int id, String estado) async {
    await _dio.patch('/api/residencias/$id/estado', queryParameters: {'estado': estado});
  }

  @override
  Future<void> assignResidentes(int residenciaId, List<int> residenteIds) async {
    await _dio.post('/api/residencias/$residenciaId/residentes', data: residenteIds);
  }
}
