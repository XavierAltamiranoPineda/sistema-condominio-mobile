import '../models/residencia.dart';

abstract class ResidenciaRepository {
  Future<List<Residencia>> getResidencias();
  Future<Residencia> createResidencia(Residencia residencia);
  Future<Residencia> updateResidencia(int id, Residencia residencia);
  Future<void> changeState(int id, String estado);
  Future<void> assignResidentes(int residenciaId, List<int> residenteIds);
}
