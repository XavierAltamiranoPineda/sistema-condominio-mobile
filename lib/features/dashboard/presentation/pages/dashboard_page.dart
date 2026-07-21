import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/dashboard_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/presentation/widgets/app_drawer.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsState = ref.watch(dashboardStatsProvider);

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
      body: statsState.when(
        data: (stats) => RefreshIndicator(
          onRefresh: () => ref.read(dashboardStatsProvider.notifier).fetchStats(),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildStatCard('Total Residentes', stats.totalResidentes.toString(), Icons.people, Colors.blue),
              _buildStatCard('Total Residencias', stats.totalResidencias.toString(), Icons.house, Colors.green),
              _buildStatCard('Pagos Pendientes', stats.pagosPendientes.toString(), Icons.payment, Colors.orange),
              _buildStatCard('Recaudación', '\$${stats.recaudacion.toStringAsFixed(2)}', Icons.attach_money, Colors.purple),
              _buildStatCard('Comunicados Activos', stats.comunicadosActivos.toString(), Icons.message, Colors.red),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error al cargar datos: $e')),
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
