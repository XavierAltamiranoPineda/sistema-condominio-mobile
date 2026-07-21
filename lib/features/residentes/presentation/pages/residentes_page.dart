import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/residente_provider.dart';
import '../../domain/models/residente.dart';
import '../../../../core/presentation/widgets/app_drawer.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/storage/providers.dart';

class ResidentesPage extends ConsumerWidget {
  const ResidentesPage({super.key});

  void _showForm(BuildContext context, WidgetRef ref, [Residente? residente]) {
    final formKey = GlobalKey<FormState>();
    final nombreCtrl = TextEditingController(text: residente?.nombres);
    final apellidoCtrl = TextEditingController(text: residente?.apellidos);
    final cedulaCtrl = TextEditingController(text: residente?.cedula);
    final telefonoCtrl = TextEditingController(text: residente?.telefono);
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(residente == null ? 'Nuevo Residente' : 'Editar Residente'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nombreCtrl,
                  decoration: const InputDecoration(labelText: 'Nombres'),
                  validator: (v) => v!.isEmpty ? 'Requerido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: apellidoCtrl,
                  decoration: const InputDecoration(labelText: 'Apellidos'),
                  validator: (v) => v!.isEmpty ? 'Requerido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: cedulaCtrl,
                  decoration: const InputDecoration(labelText: 'Cédula'),
                  validator: (v) => v!.isEmpty ? 'Requerido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: telefonoCtrl,
                  decoration: const InputDecoration(labelText: 'Teléfono'),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final r = Residente(
                  idResidente: residente?.idResidente ?? 0,
                  nombres: nombreCtrl.text,
                  apellidos: apellidoCtrl.text,
                  cedula: cedulaCtrl.text,
                  telefono: telefonoCtrl.text,
                  estado: residente?.estado ?? 'ACTIVO',
                  createdAt: residente?.createdAt ?? '',
                );
                if (residente == null) {
                  ref.read(residentesListProvider.notifier).addResidente(r);
                } else {
                  ref.read(residentesListProvider.notifier).editResidente(r.idResidente, r);
                }
                Navigator.pop(ctx);
              }
            },
            child: const Text('Guardar'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(residentesListProvider);
    final isAdmin = ref.watch(authStateProvider).maybeWhen(
      data: (auth) {
         final roles = ref.read(localStorageProvider).getRoles() ?? [];
         return roles.contains('ROLE_ADMINISTRADOR');
      },
      orElse: () => false,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Residentes')),
      drawer: const AppDrawer(),
      body: state.when(
        data: (list) => RefreshIndicator(
          onRefresh: () => ref.read(residentesListProvider.notifier).fetchResidentes(),
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final r = list[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: r.estado == 'ACTIVO' ? Colors.green : Colors.grey,
                          child: const Icon(Icons.person, color: Colors.white),
                        ),
                        title: Text('${r.nombres} ${r.apellidos}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text('C.I: ${r.cedula}'),
                            if (r.telefono.isNotEmpty) Text('Teléfono: ${r.telefono}'),
                            Row(
                              children: [
                                const Text('Estado: '),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: r.estado == 'ACTIVO' ? Colors.green.shade100 : Colors.red.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    r.estado,
                                    style: TextStyle(
                                      color: r.estado == 'ACTIVO' ? Colors.green.shade800 : Colors.red.shade800,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: isAdmin ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _showForm(context, ref, r)),
                            IconButton(
                              icon: Icon(r.estado == 'ACTIVO' ? Icons.check_circle : Icons.block, color: r.estado == 'ACTIVO' ? Colors.green : Colors.red),
                              tooltip: r.estado == 'ACTIVO' ? 'Desactivar' : 'Activar',
                              onPressed: () => ref.read(residentesListProvider.notifier).toggleEstado(r.idResidente, r.estado),
                            ),
                          ],
                        ) : null,
                      ),
                    ],
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
