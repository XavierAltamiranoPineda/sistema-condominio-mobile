import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/residentes/presentation/pages/residentes_page.dart';
import '../../features/residencias/presentation/pages/residencias_page.dart';
import '../../features/pagos/presentation/pages/pagos_page.dart';
import '../../features/comunicados/presentation/pages/comunicados_page.dart';
import '../../features/reportes/presentation/pages/reportes_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isAuth = authState.maybeWhen(
        data: (auth) => auth,
        orElse: () => false,
      );
      
      final isLoggingIn = state.uri.toString() == '/login';

      if (!isAuth && !isLoggingIn) return '/login';
      if (isAuth && isLoggingIn) return '/';

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const DashboardPage(),
      ),
      GoRoute(
        path: '/residentes',
        builder: (context, state) => const ResidentesPage(),
      ),
      GoRoute(
        path: '/residencias',
        builder: (context, state) => const ResidenciasPage(),
      ),
      GoRoute(
        path: '/pagos',
        builder: (context, state) => const PagosPage(),
      ),
      GoRoute(
        path: '/comunicados',
        builder: (context, state) => const ComunicadosPage(),
      ),
      GoRoute(
        path: '/reportes',
        builder: (context, state) => const ReportesPage(),
      ),
    ],
  );
});
