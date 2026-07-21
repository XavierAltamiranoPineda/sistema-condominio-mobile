import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/pago_provider.dart';
import '../../domain/models/pago.dart';
import '../../../../core/presentation/widgets/app_drawer.dart';

class PagosPage extends ConsumerWidget {
  const PagosPage({super.key});

  void _showForm(BuildContext context, WidgetRef ref) {
    final _formKey = GlobalKey<FormState>();
    final _montoCtrl = TextEditingController();
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Registrar Pago'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _montoCtrl,
                decoration: const InputDecoration(labelText: 'Monto (\$)'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 16),
              const Text('Nota: En producción se seleccionaría el Residente de una lista desplegable.', style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final monto = double.tryParse(_montoCtrl.text) ?? 0.0;
                final p = Pago(
                  id: 0,
                  monto: monto,
                  fecha: DateTime.now().toIso8601String(),
                  estado: 'APROBADO',
                );
                ref.read(pagosListProvider.notifier).registrarPago(p);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Registrar'),
          )
        ],
      ),
    );
  }

  void _consultarDeuda(BuildContext context, WidgetRef ref) async {
    // Demo ID for consulting debt
    const demoResidenteId = 1;
    try {
      final deuda = await ref.read(pagosListProvider.notifier).consultarDeuda(demoResidenteId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Deuda del residente (ID: $demoResidenteId): \$${deuda.toStringAsFixed(2)}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al consultar deuda: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pagosListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Consultar Deuda (Demo)',
            onPressed: () => _consultarDeuda(context, ref),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: state.when(
        data: (list) => RefreshIndicator(
          onRefresh: () => ref.read(pagosListProvider.notifier).fetchPagos(),
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final p = list[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: p.estado == 'APROBADO' ? Colors.green : Colors.orange,
                    child: const Icon(Icons.attach_money, color: Colors.white),
                  ),
                  title: Text('\$${p.monto.toStringAsFixed(2)}'),
                  subtitle: Text('Fecha: ${p.fecha.split('T').first}'),
                  trailing: Text(p.estado, style: TextStyle(
                    color: p.estado == 'APROBADO' ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.bold,
                  )),
                ),
              );
            },
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }
}
