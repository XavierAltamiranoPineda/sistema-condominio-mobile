import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/residencia_provider.dart';
import '../../domain/models/residencia.dart';
import '../../../residentes/presentation/providers/residente_provider.dart';
import '../../../../core/presentation/widgets/app_drawer.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/storage/providers.dart';

class ResidenciasPage extends ConsumerWidget {
  const ResidenciasPage({super.key});

  void _showForm(BuildContext context, WidgetRef ref, [Residencia? residencia]) {
    final formKey = GlobalKey<FormState>();
    final codigoCtrl = TextEditingController(text: residencia?.codigoCasa);
    final cuotaCtrl = TextEditingController(text: residencia?.cuotaMensual.toString());
    
    int? selectedPropietarioId = residencia?.idPropietario;

    showDialog(
      context: context,
      builder: (ctx) {
        return Consumer(
          builder: (context, ref, child) {
            return StatefulBuilder(
              builder: (context, setState) {
                final residentesState = ref.watch(residentesListProvider);
                
                return AlertDialog(
                  title: Text(residencia == null ? 'Nueva Residencia' : 'Editar Residencia'),
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
                              TextFormField(
                                controller: codigoCtrl,
                                decoration: const InputDecoration(labelText: 'Código (Ej. A-101)'),
                                validator: (v) => v!.isEmpty ? 'Requerido' : null,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: cuotaCtrl,
                                decoration: const InputDecoration(labelText: 'Cuota Mensual'),
                                keyboardType: TextInputType.number,
                                validator: (v) => v!.isEmpty ? 'Requerido' : null,
                              ),
                              const SizedBox(height: 16),
                              residentesState.when(
                                data: (residentes) => DropdownButtonFormField<int>(
                                  value: selectedPropietarioId,
                                  decoration: const InputDecoration(labelText: 'Propietario (Residente)'),
                                  isExpanded: true,
                                  items: residentes.map((r) => DropdownMenuItem(
                                    value: r.idResidente,
                                    child: Text('${r.nombres} ${r.apellidos} ${r.estado == 'INACTIVO' ? '(Inactivo)' : ''}', overflow: TextOverflow.ellipsis),
                                  )).toList(),
                                  onChanged: (v) {
                                    final res = residentes.firstWhere((r) => r.idResidente == v);
                                    if (res.estado == 'INACTIVO') {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('El residente seleccionado está inactivo y no puede ser propietario de una residencia')),
                                      );
                                      setState(() {
                                        selectedPropietarioId = null;
                                      });
                                    } else {
                                      setState(() {
                                        selectedPropietarioId = v;
                                      });
                                    }
                                  },
                                  validator: (v) => v == null ? 'Seleccione un propietario' : null,
                                ),
                                loading: () => const CircularProgressIndicator(),
                                error: (e, _) => const Text('Error al cargar propietarios'),
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
                          if (selectedPropietarioId == null) {
                            return; // just in case
                          }
                          final r = Residencia(
                            idResidencia: residencia?.idResidencia ?? 0,
                            codigoCasa: codigoCtrl.text,
                            idPropietario: selectedPropietarioId!,
                            nombrePropietario: '', // will be ignored/resolved by backend
                            cuotaMensual: double.tryParse(cuotaCtrl.text) ?? 0.0,
                            estado: residencia?.estado ?? 'DESOCUPADA',
                            createdAt: residencia?.createdAt ?? '',
                          );
                          if (residencia == null) {
                            ref.read(residenciasListProvider.notifier).addResidencia(r);
                          } else {
                            ref.read(residenciasListProvider.notifier).editResidencia(r.idResidencia, r);
                          }
                          Navigator.pop(ctx);
                        }
                      },
                      child: const Text('Guardar'),
                    )
                  ],
                );
              }
            );
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(residenciasListProvider);
    final isAdmin = ref.watch(authStateProvider).maybeWhen(
      data: (auth) {
         final roles = ref.read(localStorageProvider).getRoles() ?? [];
         return roles.contains('ROLE_ADMINISTRADOR');
      },
      orElse: () => false,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Residencias')),
      drawer: const AppDrawer(),
      body: state.when(
        data: (list) => RefreshIndicator(
          onRefresh: () => ref.read(residenciasListProvider.notifier).fetchResidencias(),
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final r = list[index];
              final isOcupada = r.estado == 'OCUPADA';
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isOcupada ? Colors.green : Colors.grey,
                      child: const Icon(Icons.house, color: Colors.white),
                    ),
                    title: Text('Unidad: ${r.codigoCasa}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text('Estado: ${r.estado}'),
                        Text('Cuota: \$${r.cuotaMensual.toStringAsFixed(2)}'),
                        if (r.nombrePropietario.isNotEmpty)
                          Text('Propietario: ${r.nombrePropietario}'),
                      ],
                    ),
                    trailing: isAdmin ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _showForm(context, ref, r)),
                        IconButton(
                          icon: Icon(isOcupada ? Icons.block : Icons.check_circle, color: isOcupada ? Colors.red : Colors.green),
                          onPressed: () => ref.read(residenciasListProvider.notifier).toggleEstado(r.idResidencia, r.estado),
                        ),
                      ],
                    ) : null,
                  ),
                ),
              );
            },
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: isAdmin ? FloatingActionButton(
        onPressed: () => _showForm(context, ref),
        child: const Icon(Icons.add),
      ) : null,
    );
  }
}
