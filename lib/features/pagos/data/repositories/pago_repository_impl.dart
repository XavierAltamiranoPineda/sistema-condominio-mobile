import 'package:dio/dio.dart';
import '../../domain/models/pago.dart';
import '../../domain/models/cuota.dart';
import '../../domain/repositories/pago_repository.dart';

class PagoRepositoryImpl implements PagoRepository {
  final Dio _dio;

  PagoRepositoryImpl(this._dio);

  @override
  Future<List<Pago>> getPagos() async {
    final response = await _dio.get('/api/pagos');
    return (response.data as List).map((e) => Pago.fromJson(e)).toList();
  }

  @override
  Future<Pago> registrarPago(Pago pago) async {
    final Map<String, dynamic> requestData = {
      'idCuota': pago.idCuota,
      'montoPagado': pago.montoPagado,
    };
    final response = await _dio.post('/api/pagos', data: requestData);
    return Pago.fromJson(response.data);
  }

  @override
  Future<double> consultarDeuda(int residenteId) async {
    final response = await _dio.get('/api/pagos/deuda/$residenteId');
    return double.parse(response.data.toString());
  }

  @override
  Future<List<Cuota>> getCuotas() async {
    final response = await _dio.get('/api/cuotas');
    return (response.data as List).map((e) => Cuota.fromJson(e)).toList();
  }

  @override
  Future<Cuota> generarCuota(Cuota cuota) async {
    final Map<String, dynamic> requestData = {
      'idResidencia': cuota.idResidencia,
      'mes': cuota.mes,
      'anio': cuota.anio,
      'valor': cuota.valor,
    };
    final response = await _dio.post('/api/cuotas', data: requestData);
    return Cuota.fromJson(response.data);
  }
}
