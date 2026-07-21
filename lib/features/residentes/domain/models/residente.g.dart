// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'residente.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Residente _$ResidenteFromJson(Map<String, dynamic> json) => Residente(
  id: (json['id'] as num).toInt(),
  nombre: json['nombre'] as String,
  apellido: json['apellido'] as String,
  cedula: json['cedula'] as String,
  estado: json['estado'] as String,
);

Map<String, dynamic> _$ResidenteToJson(Residente instance) => <String, dynamic>{
  'id': instance.id,
  'nombre': instance.nombre,
  'apellido': instance.apellido,
  'cedula': instance.cedula,
  'estado': instance.estado,
};
