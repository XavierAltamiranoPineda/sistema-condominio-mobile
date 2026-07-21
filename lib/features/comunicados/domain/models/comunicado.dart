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

  factory Comunicado.fromJson(Map<String, dynamic> json) {
    return Comunicado(
      id: (json['id'] as num?)?.toInt() ?? 0,
      titulo: json['titulo']?.toString() ?? '',
      mensaje: json['mensaje']?.toString() ?? '',
      prioridad: json['prioridad']?.toString() ?? 'NORMAL',
      fecha: json['fecha']?.toString() ?? '',
      estado: json['estado']?.toString() ?? 'ACTIVO',
      leido: json['leido'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'mensaje': mensaje,
      'prioridad': prioridad,
      'fecha': fecha,
      'estado': estado,
      'leido': leido,
    };
  }
}
