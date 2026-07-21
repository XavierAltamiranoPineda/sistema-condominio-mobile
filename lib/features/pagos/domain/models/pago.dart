import '../../../residentes/domain/models/residente.dart';

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

  factory Pago.fromJson(Map<String, dynamic> json) {
    return Pago(
      id: (json['id'] as num?)?.toInt() ?? 0,
      monto: (json['monto'] as num?)?.toDouble() ?? 0.0,
      fecha: json['fecha']?.toString() ?? '',
      estado: json['estado']?.toString() ?? 'PENDIENTE',
      residente: json['residente'] != null
          ? Residente.fromJson(json['residente'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'monto': monto,
      'fecha': fecha,
      'estado': estado,
      if (residente != null) 'residente': residente!.toJson(),
    };
  }
}
