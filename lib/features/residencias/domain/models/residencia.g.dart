// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'residencia.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Residencia _$ResidenciaFromJson(Map<String, dynamic> json) => Residencia(
  id: (json['id'] as num).toInt(),
  codigo: json['codigo'] as String,
  estado: json['estado'] as String,
  residentes:
      (json['residentes'] as List<dynamic>?)
          ?.map((e) => Residente.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$ResidenciaToJson(Residencia instance) =>
    <String, dynamic>{
      'id': instance.id,
      'codigo': instance.codigo,
      'estado': instance.estado,
      'residentes': instance.residentes,
    };
