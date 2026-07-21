import '../../../residentes/domain/models/residente.dart';

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

  factory Residencia.fromJson(Map<String, dynamic> json) {
    return Residencia(
      id: (json['id'] as num?)?.toInt() ?? 0,
      codigo: json['codigo']?.toString() ?? '',
      estado: json['estado']?.toString() ?? 'DESOCUPADA',
      residentes: (json['residentes'] as List<dynamic>?)
              ?.map((e) => Residente.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'codigo': codigo,
      'estado': estado,
      'residentes': residentes.map((r) => r.toJson()).toList(),
    };
  }
}
