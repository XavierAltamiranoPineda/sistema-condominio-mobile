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
    final _formKey = GlobalKey<FormState>();
    final _nombreCtrl = TextEditingController(text: residente?.nombre);
    final _apellidoCtrl = TextEditingController(text: residente?.apellido);
    final _cedulaCtrl = TextEditingController(text: residente?.cedula);
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(residente == null ? 'Nuevo Residente' : 'Editar Residente'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nombreCtrl,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _apellidoCtrl,
                decoration: const InputDecoration(labelText: 'Apellido'),
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cedulaCtrl,
                decoration: const InputDecoration(labelText: 'Cédula'),
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
                final r = Residente(
                  id: residente?.id ?? 0,
                  nombre: _nombreCtrl.text,
                  apellido: _apellidoCtrl.text,
                  cedula: _cedulaCtrl.text,
                  estado: residente?.estado ?? 'ACTIVO',
                );
                if (residente == null) {
                  ref.read(residentesListProvider.notifier).addResidente(r);
                } else {
                  ref.read(residentesListProvider.notifier).editResidente(r.id, r);
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
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: r.estado == 'ACTIVO' ? Colors.green : Colors.grey,
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text('${r.nombre} ${r.apellido}'),
                  subtitle: Text('C.I: ${r.cedula}'),
                  trailing: isAdmin ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _showForm(context, ref, r)),
                      IconButton(
                        icon: Icon(r.estado == 'ACTIVO' ? Icons.block : Icons.check_circle, color: r.estado == 'ACTIVO' ? Colors.red : Colors.green),
                        onPressed: () => ref.read(residentesListProvider.notifier).toggleEstado(r.id, r.estado),
                      ),
                    ],
                  ) : null,
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
