// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comunicado.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comunicado _$ComunicadoFromJson(Map<String, dynamic> json) => Comunicado(
  id: (json['id'] as num).toInt(),
  titulo: json['titulo'] as String,
  mensaje: json['mensaje'] as String,
  prioridad: json['prioridad'] as String,
  fecha: json['fecha'] as String,
  estado: json['estado'] as String,
  leido: json['leido'] as bool? ?? false,
);

Map<String, dynamic> _$ComunicadoToJson(Comunicado instance) =>
    <String, dynamic>{
      'id': instance.id,
      'titulo': instance.titulo,
      'mensaje': instance.mensaje,
      'prioridad': instance.prioridad,
      'fecha': instance.fecha,
      'estado': instance.estado,
      'leido': instance.leido,
    };
