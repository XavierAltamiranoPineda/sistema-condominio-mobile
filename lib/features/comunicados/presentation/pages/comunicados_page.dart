import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/comunicado_provider.dart';
import '../../domain/models/comunicado.dart';
import '../../../residentes/presentation/providers/residente_provider.dart';
import '../../../../core/presentation/widgets/app_drawer.dart';

class ComunicadosPage extends ConsumerWidget {
  const ComunicadosPage({super.key});

  void _showForm(BuildContext context, WidgetRef ref, [Comunicado? comunicado]) {
    final formKey = GlobalKey<FormState>();
    final tituloCtrl = TextEditingController(text: comunicado?.titulo);
    final mensajeCtrl = TextEditingController(text: comunicado?.mensaje);
    final fechaVencCtrl = TextEditingController(text: comunicado?.fechaVencimiento);
    
    String prioridad = comunicado?.prioridad ?? 'NORMAL';
    String tipo = (comunicado?.destinatarios?.isNotEmpty ?? false) ? 'INDIVIDUAL' : 'GENERAL';
    List<int> selectedDestinatarios = comunicado?.destinatarios?.toList() ?? [];

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            final residentesState = ref.watch(residentesListProvider);
            return AlertDialog(
              title: Text(comunicado == null ? 'Nuevo Comunicado' : 'Editar Comunicado'),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: tituloCtrl,
                        decoration: const InputDecoration(labelText: 'Título'),
                        validator: (v) => v!.isEmpty ? 'Requerido' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: mensajeCtrl,
                        decoration: const InputDecoration(labelText: 'Mensaje'),
                        maxLines: 3,
                        validator: (v) => v!.isEmpty ? 'Requerido' : null,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: prioridad,
                        decoration: const InputDecoration(labelText: 'Prioridad'),
                        items: const [
                          DropdownMenuItem(value: 'ALTA', child: Text('ALTA')),
                          DropdownMenuItem(value: 'NORMAL', child: Text('NORMAL')),
                          DropdownMenuItem(value: 'BAJA', child: Text('BAJA')),
                        ],
                        onChanged: (v) => setState(() => prioridad = v!),
                        validator: (v) => v == null ? 'Requerido' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: fechaVencCtrl,
                        decoration: const InputDecoration(labelText: 'Fecha Vencimiento (YYYY-MM-DD) (Opcional)'),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: tipo,
                        decoration: const InputDecoration(labelText: 'Tipo de Comunicado'),
                        items: const [
                          DropdownMenuItem(value: 'GENERAL', child: Text('GENERAL')),
                          DropdownMenuItem(value: 'INDIVIDUAL', child: Text('INDIVIDUAL')),
                        ],
                        onChanged: (v) => setState(() {
                          tipo = v!;
                          if (tipo == 'GENERAL') {
                            selectedDestinatarios.clear();
                          }
                        }),
                      ),
                      if (tipo == 'INDIVIDUAL') ...[
                        const SizedBox(height: 16),
                        const Text('Seleccionar Destinatarios:', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Container(
                          height: 150,
                          decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                          child: residentesState.when(
                            data: (residentes) {
                              if (residentes.isEmpty) return const Center(child: Text('No hay residentes'));
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: residentes.length,
                                itemBuilder: (context, index) {
                                  final r = residentes[index];
                                  final isSelected = selectedDestinatarios.contains(r.idResidente);
                                  return CheckboxListTile(
                                    title: Text('${r.nombres} ${r.apellidos}'),
                                    value: isSelected,
                                    onChanged: (val) {
                                      setState(() {
                                        if (val == true) {
                                          selectedDestinatarios.add(r.idResidente);
                                        } else {
                                          selectedDestinatarios.remove(r.idResidente);
                                        }
                                      });
                                    },
                                  );
                                },
                              );
                            },
                            loading: () => const Center(child: CircularProgressIndicator()),
                            error: (e, _) => const Center(child: Text('Error al cargar')),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      if (tipo == 'INDIVIDUAL' && selectedDestinatarios.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Debe seleccionar al menos un destinatario.')));
                        return;
                      }
                      
                      final c = Comunicado(
                        idComunicado: comunicado?.idComunicado ?? 0,
                        titulo: tituloCtrl.text,
                        mensaje: mensajeCtrl.text,
                        prioridad: prioridad,
                        fechaVencimiento: fechaVencCtrl.text.isEmpty ? null : fechaVencCtrl.text,
                        createdAt: comunicado?.createdAt ?? DateTime.now().toIso8601String(),
                        destinatarios: tipo == 'INDIVIDUAL' ? selectedDestinatarios : null,
                      );
                      if (comunicado == null) {
                        ref.read(comunicadosListProvider.notifier).addComunicado(c);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Comunicado creado exitosamente.')));
                      } else {
                        ref.read(comunicadosListProvider.notifier).editComunicado(c.idComunicado, c);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Comunicado editado exitosamente.')));
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
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(comunicadosListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Comunicados')),
      drawer: const AppDrawer(),
      body: state.when(
        data: (list) {
          if (list.isEmpty) {
            return const Center(child: Text('No hay comunicados registrados.'));
          }
          return RefreshIndicator(
            onRefresh: () => ref.read(comunicadosListProvider.notifier).fetchComunicados(),
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                final c = list[index];
                final Color prioridadColor = c.prioridad == 'ALTA' ? Colors.red : (c.prioridad == 'BAJA' ? Colors.blue : Colors.orange);
                
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            c.titulo,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: prioridadColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            c.prioridad,
                            style: TextStyle(color: prioridadColor, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(c.mensaje),
                          const SizedBox(height: 8),
                          Text(
                            'Publicado: ${c.createdAt.split('T').first}' +
                            (c.fechaVencimiento != null ? ' | Vence: ${c.fechaVencimiento!.split('T').first}' : ''),
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showForm(context, ref, c),
                    ),
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
        onPressed: () => _showForm(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }
}
