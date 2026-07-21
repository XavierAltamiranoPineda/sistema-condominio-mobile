import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/pago_provider.dart';
import '../../domain/models/cuota.dart';
import '../../../residencias/presentation/providers/residencia_provider.dart';
import '../../../../core/presentation/widgets/app_drawer.dart';

class PagosPage extends ConsumerWidget {
  const PagosPage({super.key});

  void _showCuotaForm(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final valorCtrl = TextEditingController();
    int? selectedResidenciaId;
    int selectedMes = DateTime.now().month;
    int selectedAnio = DateTime.now().year < 2025 ? 2025 : (DateTime.now().year > 2026 ? 2026 : DateTime.now().year);

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            final residenciasState = ref.watch(residenciasListProvider);
            return AlertDialog(
              title: const Text('Generar Cuota Mensual'),
              content: Form(
                key: formKey,
                child: SafeArea(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.5,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          residenciasState.when(
                            data: (residencias) => DropdownButtonFormField<int>(
                              value: selectedResidenciaId,
                              decoration: const InputDecoration(labelText: 'Residencia'),
                              isExpanded: true,
                              items: residencias.map((r) => DropdownMenuItem(
                                value: r.idResidencia,
                                child: Text(r.codigoCasa, overflow: TextOverflow.ellipsis),
                              )).toList(),
                              onChanged: (v) => setState(() => selectedResidenciaId = v),
                              validator: (v) => v == null ? 'Seleccione una residencia' : null,
                            ),
                            loading: () => const CircularProgressIndicator(),
                            error: (e, _) => const Text('Error cargando residencias'),
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<int>(
                            value: selectedMes,
                            decoration: const InputDecoration(labelText: 'Mes'),
                            items: List.generate(12, (i) => i + 1).map((m) => DropdownMenuItem(
                              value: m,
                              child: Text('Mes $m'),
                            )).toList(),
                            onChanged: (v) => setState(() => selectedMes = v!),
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<int>(
                            value: selectedAnio,
                            decoration: const InputDecoration(labelText: 'Año'),
                            items: const [
                              DropdownMenuItem(value: 2025, child: Text('2025')),
                              DropdownMenuItem(value: 2026, child: Text('2026')),
                            ],
                            onChanged: (v) => setState(() => selectedAnio = v!),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: valorCtrl,
                            decoration: const InputDecoration(labelText: 'Valor Cuota (\$)'),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            validator: (v) {
                              if (v!.isEmpty) return 'Requerido';
                              final val = double.tryParse(v);
                              if (val == null || val <= 0) return 'Debe ser mayor que 0';
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      final cuota = Cuota(
                        idCuota: 0,
                        idResidencia: selectedResidenciaId!,
                        codigoCasa: '',
                        mes: selectedMes,
                        anio: selectedAnio,
                        valor: double.parse(valorCtrl.text),
                        montoPagado: 0,
                        saldoPendiente: 0,
                      );
                      ref.read(cuotasListProvider.notifier).generarCuota(cuota);
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cuota generada exitosamente.')));
                    }
                  },
                  child: const Text('Generar'),
                )
              ],
            );
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cuotasListProvider);
    
    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de Cuotas')),
      drawer: const AppDrawer(),
      body: state.when(
        data: (list) {
          if (list.isEmpty) return const Center(child: Text('No hay cuotas.'));
          return RefreshIndicator(
            onRefresh: () => ref.read(cuotasListProvider.notifier).fetchCuotas(),
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                final c = list[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.receipt, color: Colors.white),
                    ),
                    title: Text('Casa: ${c.codigoCasa} - Mes: ${c.mes}/${c.anio}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Valor: \$${c.valor.toStringAsFixed(2)} | Pagado: \$${c.montoPagado.toStringAsFixed(2)}'),
                    trailing: Text('Saldo: \$${c.saldoPendiente.toStringAsFixed(2)}', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab_cuotas',
        onPressed: () {
          ref.read(residenciasListProvider.notifier).fetchResidencias();
          _showCuotaForm(context, ref);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
