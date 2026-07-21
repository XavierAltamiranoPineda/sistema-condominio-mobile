import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/dashboard_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../residentes/presentation/providers/residente_provider.dart';
import '../../../residencias/presentation/providers/residencia_provider.dart';
import '../../../pagos/presentation/providers/pago_provider.dart';
import '../../../comunicados/presentation/providers/comunicado_provider.dart';
import '../../../../core/presentation/widgets/app_drawer.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reporteState = ref.watch(dashboardStatsProvider);
    final residentesState = ref.watch(residentesListProvider);
    final residenciasState = ref.watch(residenciasListProvider);
    final pagosState = ref.watch(pagosListProvider);
    final comunicadosState = ref.watch(comunicadosListProvider);

    final isLoading = reporteState.isLoading || residentesState.isLoading || residenciasState.isLoading || pagosState.isLoading || comunicadosState.isLoading;

    if (isLoading && (!reporteState.hasValue || !residentesState.hasValue || !residenciasState.hasValue || !pagosState.hasValue || !comunicadosState.hasValue)) {
      return Scaffold(
        appBar: AppBar(title: const Text('Dashboard')),
        drawer: const AppDrawer(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (reporteState.hasError) {
      return Scaffold(
        appBar: AppBar(title: const Text('Dashboard')),
        drawer: const AppDrawer(),
        body: Center(child: Text('Error al cargar datos: ${reporteState.error}')),
      );
    }

    final reporte = reporteState.value;
    final residentes = residentesState.value ?? [];
    final residencias = residenciasState.value ?? [];
    final pagos = pagosState.value ?? [];
    final comunicados = comunicadosState.value ?? [];

    final totalResidentes = residentes.length;
    final totalResidencias = residencias.length;
    final residenciasOcupadas = residencias.where((r) => r.estado == 'OCUPADA').length;
    final residenciasDesocupadas = residencias.where((r) => r.estado == 'DESOCUPADA').length;
    
    // As per frontend calculation:
    // Pagos Pendientes might be different but let's count pagos with some pending status or use a general logic. 
    // Wait, the API model for Pago returns `monto`. If desktop says 'cuotas' and 'pagosPendientes = cuotas.filter(c => c.saldoPendiente > 0).length', but we only have `Pago` model here. 
    // Let's adapt it to our `Pago` model. Wait, `Pago` has `estado`. So we count where `estado` is NOT 'APROBADO' maybe?
    final pagosPendientes = pagos.where((p) => p.estado != 'APROBADO').length;
    
    // Recaudación Mensual: sum of all 'APROBADO' payments.
    final recaudacion = pagos.where((p) => p.estado == 'APROBADO').fold<double>(0.0, (sum, p) => sum + p.monto);

    // Comunicados Activos: where estado != 'VENCIDO'
    final comunicadosActivos = comunicados.where((c) => c.estado.toUpperCase() != 'VENCIDO').length;

    final isEstadoOk = reporte?.estado == 'OK';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authStateProvider.notifier).logout();
            },
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(dashboardStatsProvider.notifier).fetchStats();
          ref.read(residentesListProvider.notifier).fetchResidentes();
          ref.read(residenciasListProvider.notifier).fetchResidencias();
          ref.read(pagosListProvider.notifier).fetchPagos();
          ref.read(comunicadosListProvider.notifier).fetchComunicados();
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isEstadoOk ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isEstadoOk ? Colors.green : Colors.orange),
              ),
              child: Row(
                children: [
                  Icon(isEstadoOk ? Icons.check_circle : Icons.warning, color: isEstadoOk ? Colors.green : Colors.orange),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Estado: ${reporte?.estado ?? "Desconocido"}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        if (!isEstadoOk && reporte?.novedades != null && reporte!.novedades.isNotEmpty)
                          Text('Alertas: ${reporte.novedades.map((n) => n['tipo']).join(', ')}')
                        else
                          const Text('El condominio se encuentra al día.'),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildStatCard('Total Residentes', totalResidentes.toString(), Icons.people, Colors.blue),
            _buildStatCard('Total Residencias', totalResidencias.toString(), Icons.house, Colors.indigo),
            _buildStatCard('Residencias Ocupadas', residenciasOcupadas.toString(), Icons.business, Colors.teal),
            _buildStatCard('Residencias Vacías', residenciasDesocupadas.toString(), Icons.warning_amber, Colors.orange),
            _buildStatCard('Recaudación General', '\$${recaudacion.toStringAsFixed(2)}', Icons.attach_money, Colors.green),
            _buildStatCard('Pagos Pendientes / Rechazados', pagosPendientes.toString(), Icons.payment, Colors.red),
            _buildStatCard('Comunicados Activos', comunicadosActivos.toString(), Icons.message, Colors.purple),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    value,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
