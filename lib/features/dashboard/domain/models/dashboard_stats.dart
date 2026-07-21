class ReporteGeneral {
  final String estado;
  final String mensaje;
  final List<Map<String, dynamic>> novedades;

  ReporteGeneral({
    required this.estado,
    this.mensaje = '',
    this.novedades = const [],
  });

  factory ReporteGeneral.fromJson(Map<String, dynamic> json) {
    return ReporteGeneral(
      estado: json['estado']?.toString() ?? 'OK',
      mensaje: json['mensaje']?.toString() ?? '',
      novedades: (json['novedades'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          [],
    );
  }
}
