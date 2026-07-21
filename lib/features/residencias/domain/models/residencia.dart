class Residencia {
  final int idResidencia;
  final String codigoCasa;
  final int idPropietario;
  final String nombrePropietario;
  final double cuotaMensual;
  final String estado;
  final String createdAt;

  Residencia({
    required this.idResidencia,
    required this.codigoCasa,
    required this.idPropietario,
    required this.nombrePropietario,
    required this.cuotaMensual,
    required this.estado,
    required this.createdAt,
  });

  factory Residencia.fromJson(Map<String, dynamic> json) {
    return Residencia(
      idResidencia: (json['idResidencia'] as num?)?.toInt() ?? 0,
      codigoCasa: json['codigoCasa']?.toString() ?? '',
      idPropietario: (json['idPropietario'] as num?)?.toInt() ?? 0,
      nombrePropietario: json['nombrePropietario']?.toString() ?? '',
      cuotaMensual: (json['cuotaMensual'] as num?)?.toDouble() ?? 0.0,
      estado: json['estado']?.toString() ?? 'DESOCUPADA',
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idResidencia': idResidencia,
      'codigoCasa': codigoCasa,
      'idPropietario': idPropietario,
      'nombrePropietario': nombrePropietario,
      'cuotaMensual': cuotaMensual,
      'estado': estado,
      'createdAt': createdAt,
    };
  }
}
