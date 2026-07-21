class Comunicado {
  final int idComunicado;
  final String titulo;
  final String mensaje;
  final String prioridad;
  final String? fechaVencimiento;
  final String createdAt;
  final List<int>? destinatarios;

  Comunicado({
    required this.idComunicado,
    required this.titulo,
    required this.mensaje,
    required this.prioridad,
    this.fechaVencimiento,
    required this.createdAt,
    this.destinatarios,
  });

  factory Comunicado.fromJson(Map<String, dynamic> json) {
    return Comunicado(
      idComunicado: (json['idComunicado'] as num?)?.toInt() ?? 0,
      titulo: json['titulo']?.toString() ?? '',
      mensaje: json['mensaje']?.toString() ?? '',
      prioridad: json['prioridad']?.toString() ?? 'NORMAL',
      fechaVencimiento: json['fechaVencimiento']?.toString(),
      createdAt: json['createdAt']?.toString() ?? '',
      destinatarios: json['destinatarios'] != null 
          ? List<int>.from(json['destinatarios'] as List)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idComunicado': idComunicado,
      'titulo': titulo,
      'mensaje': mensaje,
      'prioridad': prioridad,
      if (fechaVencimiento != null) 'fechaVencimiento': fechaVencimiento,
      'createdAt': createdAt,
      if (destinatarios != null) 'destinatarios': destinatarios,
    };
  }
}
