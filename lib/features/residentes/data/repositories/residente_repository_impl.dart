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
    final Map<String, dynamic> requestData = {
      'nombres': residente.nombres,
      'apellidos': residente.apellidos,
      'cedula': residente.cedula,
      'telefono': residente.telefono,
    };
    final response = await _dio.post('/api/residentes', data: requestData);
    return Residente.fromJson(response.data);
  }

  @override
  Future<Residente> updateResidente(int id, Residente residente) async {
    final Map<String, dynamic> requestData = {
      'nombres': residente.nombres,
      'apellidos': residente.apellidos,
      'cedula': residente.cedula,
      'telefono': residente.telefono,
      'estado': residente.estado,
    };
    final response = await _dio.put('/api/residentes/$id', data: requestData);
    return Residente.fromJson(response.data);
  }

  @override
  Future<void> changeState(int id, String estado) async {
    if (estado == 'INACTIVO') {
      await _dio.delete('/api/residentes/$id');
    } else {
      // Activar requires sending the data via PUT.
      // Since our interface only passes id and estado, we must fetch it first or change the interface.
      // Fetch the current record:
      final resp = await _dio.get('/api/residentes/$id');
      final currentData = resp.data as Map<String, dynamic>;
      currentData['estado'] = 'ACTIVO';
      await _dio.put('/api/residentes/$id', data: currentData);
    }
  }
}
