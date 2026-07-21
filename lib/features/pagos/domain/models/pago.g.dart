// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pago.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pago _$PagoFromJson(Map<String, dynamic> json) => Pago(
  id: (json['id'] as num).toInt(),
  monto: (json['monto'] as num).toDouble(),
  fecha: json['fecha'] as String,
  estado: json['estado'] as String,
  residente: json['residente'] == null
      ? null
      : Residente.fromJson(json['residente'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PagoToJson(Pago instance) => <String, dynamic>{
  'id': instance.id,
  'monto': instance.monto,
  'fecha': instance.fecha,
  'estado': instance.estado,
  'residente': instance.residente,
};
