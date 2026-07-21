import 'package:json_annotation/json_annotation.dart';

part 'comunicado.g.dart';

@JsonSerializable()
class Comunicado {
  final int id;
  final String titulo;
  final String mensaje;
  final String prioridad;
  final String fecha;
  final String estado;
  final bool leido;

  Comunicado({
    required this.id,
    required this.titulo,
    required this.mensaje,
    required this.prioridad,
    required this.fecha,
    required this.estado,
    this.leido = false,
  });

  factory Comunicado.fromJson(Map<String, dynamic> json) => _$ComunicadoFromJson(json);
  Map<String, dynamic> toJson() => _$ComunicadoToJson(this);
}
