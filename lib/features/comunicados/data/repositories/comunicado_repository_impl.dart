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
  Future<Comunicado> createComunicado(Comunicado comunicado) async {
    final Map<String, dynamic> requestData = {
      'titulo': comunicado.titulo,
      'mensaje': comunicado.mensaje,
      'prioridad': comunicado.prioridad,
      if (comunicado.fechaVencimiento != null) 'fechaVencimiento': comunicado.fechaVencimiento,
      if (comunicado.destinatarios != null && comunicado.destinatarios!.isNotEmpty)
        'destinatarios': comunicado.destinatarios,
    };
    final response = await _dio.post('/api/comunicados', data: requestData);
    return Comunicado.fromJson(response.data);
  }

  @override
  Future<Comunicado> updateComunicado(int id, Comunicado comunicado) async {
    final Map<String, dynamic> requestData = {
      'titulo': comunicado.titulo,
      'mensaje': comunicado.mensaje,
      'prioridad': comunicado.prioridad,
      if (comunicado.fechaVencimiento != null) 'fechaVencimiento': comunicado.fechaVencimiento,
      if (comunicado.destinatarios != null && comunicado.destinatarios!.isNotEmpty)
        'destinatarios': comunicado.destinatarios,
    };
    final response = await _dio.put('/api/comunicados/$id', data: requestData);
    return Comunicado.fromJson(response.data);
  }
}
