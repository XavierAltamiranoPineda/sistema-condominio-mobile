import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF1E88E5)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.apartment, size: 48, color: Colors.white),
                SizedBox(height: 16),
                Text('Sistema Condominio', style: TextStyle(color: Colors.white, fontSize: 20)),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.pop(context);
              if (GoRouterState.of(context).uri.toString() != '/') {
                context.go('/');
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Residentes'),
            onTap: () {
              Navigator.pop(context);
              if (GoRouterState.of(context).uri.toString() != '/residentes') {
                context.go('/residentes');
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.house),
            title: const Text('Residencias'),
            onTap: () {
              Navigator.pop(context);
              if (GoRouterState.of(context).uri.toString() != '/residencias') {
                context.go('/residencias');
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Pagos'),
            onTap: () {
              Navigator.pop(context);
              if (GoRouterState.of(context).uri.toString() != '/pagos') {
                context.go('/pagos');
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.message),
            title: const Text('Comunicados'),
            onTap: () {
              Navigator.pop(context);
              if (GoRouterState.of(context).uri.toString() != '/comunicados') {
                context.go('/comunicados');
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.picture_as_pdf),
            title: const Text('Reportes'),
            onTap: () {
              Navigator.pop(context);
              if (GoRouterState.of(context).uri.toString() != '/reportes') {
                context.go('/reportes');
              }
            },
          ),
        ],
      ),
    );
  }
}
