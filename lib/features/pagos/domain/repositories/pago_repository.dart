import '../models/pago.dart';
import '../models/cuota.dart';

abstract class PagoRepository {
  Future<List<Pago>> getPagos();
  Future<Pago> registrarPago(Pago pago);
  Future<double> consultarDeuda(int residenteId);
  Future<List<Cuota>> getCuotas();
  Future<Cuota> generarCuota(Cuota cuota);
}
