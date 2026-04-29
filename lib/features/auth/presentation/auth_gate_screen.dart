import 'package:damkina_app/core/routing/app_routes.dart';
import 'package:damkina_app/features/auth/application/auth_flow.dart';
import 'package:damkina_app/features/auth/application/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AuthGateScreen extends ConsumerStatefulWidget {
  const AuthGateScreen({super.key});

  @override
  ConsumerState<AuthGateScreen> createState() => _AuthGateScreenState();
}

class _AuthGateScreenState extends ConsumerState<AuthGateScreen> {
  String? _lastRoute;

  @override
  Widget build(BuildContext context) {
    final currentUserAsync = ref.watch(currentUserProvider);

    return currentUserAsync.when(
      data: (user) {
        _scheduleNavigation(resolvePostAuthRoute(user));
        return const _GateScaffold();
      },
      loading: _buildLoadingState,
      error: (_, _) {
        _scheduleNavigation(AppRoutes.login);
        return const _GateScaffold();
      },
    );
  }

  Widget _buildLoadingState() => const _GateScaffold();

  void _scheduleNavigation(String route) {
    if (_lastRoute == route || !mounted) {
      return;
    }

    _lastRoute = route;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      context.go(route);
    });
  }
}

class _GateScaffold extends StatelessWidget {
  const _GateScaffold();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
