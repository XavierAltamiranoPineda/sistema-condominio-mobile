import 'package:json_annotation/json_annotation.dart';
import '../../../residentes/domain/models/residente.dart';

part 'pago.g.dart';

@JsonSerializable()
class Pago {
  final int id;
  final double monto;
  final String fecha;
  final String estado;
  final Residente? residente;

  Pago({
    required this.id,
    required this.monto,
    required this.fecha,
    required this.estado,
    this.residente,
  });

  factory Pago.fromJson(Map<String, dynamic> json) => _$PagoFromJson(json);
  Map<String, dynamic> toJson() => _$PagoToJson(this);
}
