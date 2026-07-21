import '../models/pago.dart';

abstract class PagoRepository {
  Future<List<Pago>> getPagos();
  Future<Pago> registrarPago(Pago pago);
  Future<double> consultarDeuda(int residenteId);
}
