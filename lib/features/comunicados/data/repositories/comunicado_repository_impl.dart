import 'package:dio/dio.dart';
import '../../domain/models/comunicado.dart';
import '../../domain/repositories/comunicado_repository.dart';

class ComunicadoRepositoryImpl implements ComunicadoRepository {
  final Dio _dio;

  ComunicadoRepositoryImpl(this._dio);

  @override
  Future<List<Comunicado>> getComunicados() async {
    final response = await _dio.get('/api/comunicados');
    return (response.data as List).map((e) => Comunicado.fromJson(e)).toList();
  }

  @override
  Future<void> marcarLeido(int id) async {
    await _dio.patch('/api/comunicados/$id/leido');
  }
}
