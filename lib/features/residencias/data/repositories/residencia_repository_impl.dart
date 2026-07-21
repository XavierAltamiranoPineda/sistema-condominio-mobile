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
    final Map<String, dynamic> requestData = {
      'codigoCasa': residencia.codigoCasa,
      'idPropietario': residencia.idPropietario,
      'cuotaMensual': residencia.cuotaMensual,
    };
    final response = await _dio.post('/api/residencias', data: requestData);
    return Residencia.fromJson(response.data);
  }

  @override
  Future<Residencia> updateResidencia(int id, Residencia residencia) async {
    final Map<String, dynamic> requestData = {
      'codigoCasa': residencia.codigoCasa,
      'idPropietario': residencia.idPropietario,
      'cuotaMensual': residencia.cuotaMensual,
      'estado': residencia.estado,
    };
    final response = await _dio.put('/api/residencias/$id', data: requestData);
    return Residencia.fromJson(response.data);
  }

  @override
  Future<void> changeState(int id, String estado) async {
    // Desktop uses PUT with full body. Let's fetch and update.
    final resp = await _dio.get('/api/residencias/$id');
    final currentData = resp.data as Map<String, dynamic>;
    currentData['estado'] = estado;
    await _dio.put('/api/residencias/$id', data: currentData);
  }

  @override
  Future<void> assignResidentes(int residenciaId, List<int> residenteIds) async {
    await _dio.post('/api/residencias/$residenciaId/residentes', data: residenteIds);
  }
}
