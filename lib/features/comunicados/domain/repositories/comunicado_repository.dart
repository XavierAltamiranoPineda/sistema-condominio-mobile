import '../models/comunicado.dart';

abstract class ComunicadoRepository {
  Future<List<Comunicado>> getComunicados();
  Future<void> marcarLeido(int id);
}
