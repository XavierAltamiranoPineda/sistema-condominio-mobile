import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/comunicado_provider.dart';
import '../../../../core/presentation/widgets/app_drawer.dart';

class ComunicadosPage extends ConsumerWidget {
  const ComunicadosPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(comunicadosListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Comunicados')),
      drawer: const AppDrawer(),
      body: state.when(
        data: (list) => RefreshIndicator(
          onRefresh: () => ref.read(comunicadosListProvider.notifier).fetchComunicados(),
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final c = list[index];
              final Color prioridadColor = c.prioridad == 'ALTA' ? Colors.red : (c.prioridad == 'MEDIA' ? Colors.orange : Colors.blue);
              final bool isVencido = c.estado.toUpperCase() == 'VENCIDO';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: isVencido ? Colors.grey[850] : null,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          c.titulo,
                          style: TextStyle(
                            fontWeight: c.leido ? FontWeight.normal : FontWeight.bold,
                            decoration: isVencido ? TextDecoration.lineThrough : null,
                          ),
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
                          'Fecha: ${c.fecha.split('T').first} - Estado: ${c.estado}',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  trailing: !c.leido && !isVencido
                      ? IconButton(
                          icon: const Icon(Icons.check_circle_outline, color: Colors.green),
                          tooltip: 'Marcar Leído',
                          onPressed: () => ref.read(comunicadosListProvider.notifier).marcarLeido(c.id),
                        )
                      : (c.leido ? const Icon(Icons.check_circle, color: Colors.green) : null),
                ),
              );
            },
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
