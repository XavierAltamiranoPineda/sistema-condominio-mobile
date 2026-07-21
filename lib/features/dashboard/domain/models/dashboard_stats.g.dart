// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardStats _$DashboardStatsFromJson(Map<String, dynamic> json) =>
    DashboardStats(
      totalResidentes: (json['totalResidentes'] as num).toInt(),
      totalResidencias: (json['totalResidencias'] as num).toInt(),
      pagosPendientes: (json['pagosPendientes'] as num).toInt(),
      recaudacion: (json['recaudacion'] as num).toDouble(),
      comunicadosActivos: (json['comunicadosActivos'] as num).toInt(),
    );

Map<String, dynamic> _$DashboardStatsToJson(DashboardStats instance) =>
    <String, dynamic>{
      'totalResidentes': instance.totalResidentes,
      'totalResidencias': instance.totalResidencias,
      'pagosPendientes': instance.pagosPendientes,
      'recaudacion': instance.recaudacion,
      'comunicadosActivos': instance.comunicadosActivos,
    };
