class Residente {
  final int idResidente;
  final String nombres;
  final String apellidos;
  final String cedula;
  final String telefono;
  final String estado;
  final String createdAt;

  Residente({
    required this.idResidente,
    required this.nombres,
    required this.apellidos,
    required this.cedula,
    required this.telefono,
    required this.estado,
    required this.createdAt,
  });

  factory Residente.fromJson(Map<String, dynamic> json) {
    return Residente(
      idResidente: (json['idResidente'] as num?)?.toInt() ?? 0,
      nombres: json['nombres']?.toString() ?? '',
      apellidos: json['apellidos']?.toString() ?? '',
      cedula: json['cedula']?.toString() ?? '',
      telefono: json['telefono']?.toString() ?? '',
      estado: json['estado']?.toString().toUpperCase() ?? 'INACTIVO',
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idResidente': idResidente,
      'nombres': nombres,
      'apellidos': apellidos,
      'cedula': cedula,
      'telefono': telefono,
      'estado': estado,
      'createdAt': createdAt,
    };
  }
}
