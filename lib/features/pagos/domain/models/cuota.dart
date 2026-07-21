class Cuota {
  final int idCuota;
  final int idResidencia;
  final String codigoCasa;
  final int mes;
  final int anio;
  final double valor;
  final double montoPagado;
  final double saldoPendiente;

  Cuota({
    required this.idCuota,
    required this.idResidencia,
    required this.codigoCasa,
    required this.mes,
    required this.anio,
    required this.valor,
    required this.montoPagado,
    required this.saldoPendiente,
  });

  factory Cuota.fromJson(Map<String, dynamic> json) {
    return Cuota(
      idCuota: (json['idCuota'] as num?)?.toInt() ?? 0,
      idResidencia: (json['idResidencia'] as num?)?.toInt() ?? 0,
      codigoCasa: json['codigoCasa']?.toString() ?? '',
      mes: (json['mes'] as num?)?.toInt() ?? 0,
      anio: (json['anio'] as num?)?.toInt() ?? 0,
      valor: (json['valor'] as num?)?.toDouble() ?? 0.0,
      montoPagado: (json['montoPagado'] as num?)?.toDouble() ?? 0.0,
      saldoPendiente: (json['saldoPendiente'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idCuota': idCuota,
      'idResidencia': idResidencia,
      'codigoCasa': codigoCasa,
      'mes': mes,
      'anio': anio,
      'valor': valor,
      'montoPagado': montoPagado,
      'saldoPendiente': saldoPendiente,
    };
  }
}
