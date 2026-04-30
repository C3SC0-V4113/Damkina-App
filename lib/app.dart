import 'package:damkina_app/core/routing/app_router.dart';
import 'package:damkina_app/core/theme/app_theme.dart';
import 'package:damkina_app/features/auth/application/auth_providers.dart';
import 'package:damkina_app/shared/providers/session_reset_coordinator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DamkinaApp extends ConsumerStatefulWidget {
  const DamkinaApp({super.key});

  @override
  ConsumerState<DamkinaApp> createState() => _DamkinaAppState();
}

class _DamkinaAppState extends ConsumerState<DamkinaApp> {
  late final ProviderSubscription<AsyncValue<int>> _sessionResetSubscription;

  @override
  void initState() {
    super.initState();
    _sessionResetSubscription = ref.listenManual(
      authStateChangesProvider,
      (previous, next) {
        if (next is AsyncData<int>) {
          ref.read(sessionResetCoordinatorProvider).resetUserScopedState();
        }
      },
    );
  }

  @override
  void dispose() {
    _sessionResetSubscription.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Damkina',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: router,
    );
  }
}
