import 'package:json_annotation/json_annotation.dart';

part 'dashboard_stats.g.dart';

@JsonSerializable()
class DashboardStats {
  final int totalResidentes;
  final int totalResidencias;
  final int pagosPendientes;
  final double recaudacion;
  final int comunicadosActivos;

  DashboardStats({
    required this.totalResidentes,
    required this.totalResidencias,
    required this.pagosPendientes,
    required this.recaudacion,
    required this.comunicadosActivos,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) => _$DashboardStatsFromJson(json);
  Map<String, dynamic> toJson() => _$DashboardStatsToJson(this);
}
