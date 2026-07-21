import 'package:json_annotation/json_annotation.dart';
import '../../../residentes/domain/models/residente.dart';

part 'residencia.g.dart';

@JsonSerializable()
class Residencia {
  final int id;
  final String codigo;
  final String estado;
  final List<Residente> residentes;

  Residencia({
    required this.id,
    required this.codigo,
    required this.estado,
    this.residentes = const [],
  });

  factory Residencia.fromJson(Map<String, dynamic> json) => _$ResidenciaFromJson(json);
  Map<String, dynamic> toJson() => _$ResidenciaToJson(this);
}
