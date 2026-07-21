import '../models/comunicado.dart';

abstract class ComunicadoRepository {
  Future<List<Comunicado>> getComunicados();
  Future<Comunicado> createComunicado(Comunicado comunicado);
  Future<Comunicado> updateComunicado(int id, Comunicado comunicado);
}
