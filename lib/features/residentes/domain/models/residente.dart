import 'package:json_annotation/json_annotation.dart';

part 'residente.g.dart';

@JsonSerializable()
class Residente {
  final int id;
  final String nombre;
  final String apellido;
  final String cedula;
  final String estado;

  Residente({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.cedula,
    required this.estado,
  });

  factory Residente.fromJson(Map<String, dynamic> json) => _$ResidenteFromJson(json);
  Map<String, dynamic> toJson() => _$ResidenteToJson(this);
}
