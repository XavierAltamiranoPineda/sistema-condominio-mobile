import 'package:dio/dio.dart';
import '../../domain/models/pago.dart';
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
    final response = await _dio.post('/api/pagos', data: pago.toJson());
    return Pago.fromJson(response.data);
  }

  @override
  Future<double> consultarDeuda(int residenteId) async {
    final response = await _dio.get('/api/pagos/deuda/$residenteId');
    return double.parse(response.data.toString());
  }
}
