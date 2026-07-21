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

  factory Residente.fromJson(Map<String, dynamic> json) {
    return Residente(
      id: (json['id'] as num?)?.toInt() ?? 0,
      nombre: json['nombre']?.toString() ?? '',
      apellido: json['apellido']?.toString() ?? '',
      cedula: json['cedula']?.toString() ?? '',
      estado: json['estado']?.toString() ?? 'INACTIVO',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'apellido': apellido,
      'cedula': cedula,
      'estado': estado,
    };
  }
}
