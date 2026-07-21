import '../models/residente.dart';

abstract class ResidenteRepository {
  Future<List<Residente>> getResidentes();
  Future<Residente> createResidente(Residente residente);
  Future<Residente> updateResidente(int id, Residente residente);
  Future<void> changeState(int id, String estado);
}
