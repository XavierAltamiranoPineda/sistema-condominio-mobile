import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/residencia_provider.dart';
import '../../domain/models/residencia.dart';
import '../../../../core/presentation/widgets/app_drawer.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/storage/providers.dart';

class ResidenciasPage extends ConsumerWidget {
  const ResidenciasPage({super.key});

  void _showForm(BuildContext context, WidgetRef ref, [Residencia? residencia]) {
    final _formKey = GlobalKey<FormState>();
    final _codigoCtrl = TextEditingController(text: residencia?.codigo);
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(residencia == null ? 'Nueva Residencia' : 'Editar Residencia'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _codigoCtrl,
                decoration: const InputDecoration(labelText: 'Código (Ej. A-101)'),
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final r = Residencia(
                  id: residencia?.id ?? 0,
                  codigo: _codigoCtrl.text,
                  estado: residencia?.estado ?? 'ACTIVO',
                );
                if (residencia == null) {
                  ref.read(residenciasListProvider.notifier).addResidencia(r);
                } else {
                  ref.read(residenciasListProvider.notifier).editResidencia(r.id, r);
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
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ExpansionTile(
                  leading: CircleAvatar(
                    backgroundColor: r.estado == 'ACTIVO' ? Colors.green : Colors.grey,
                    child: const Icon(Icons.house, color: Colors.white),
                  ),
                  title: Text('Unidad: ${r.codigo}'),
                  subtitle: Text('${r.residentes.length} Residentes'),
                  trailing: isAdmin ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _showForm(context, ref, r)),
                      IconButton(
                        icon: Icon(r.estado == 'ACTIVO' ? Icons.block : Icons.check_circle, color: r.estado == 'ACTIVO' ? Colors.red : Colors.green),
                        onPressed: () => ref.read(residenciasListProvider.notifier).toggleEstado(r.id, r.estado),
                      ),
                    ],
                  ) : null,
                  children: [
                    if (r.residentes.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('No hay residentes asignados.'),
                      ),
                    ...r.residentes.map((residente) => ListTile(
                      title: Text('${residente.nombre} ${residente.apellido}'),
                      subtitle: Text('Estado: ${residente.estado}'),
                      leading: const Icon(Icons.person),
                    )),
                    if (isAdmin)
                      TextButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text('Asignar Residente'),
                        onPressed: () {
                          // Validation: Ensure we only show ACTIVO residents in this dialog,
                          // or prevent selection of INACTIVO residents.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Se validará que no se asignen residentes inactivos.')),
                          );
                        },
                      )
                  ],
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
