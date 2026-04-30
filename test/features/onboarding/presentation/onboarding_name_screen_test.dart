import 'dart:async';

import 'package:damkina_app/core/routing/app_routes.dart';
import 'package:damkina_app/features/auth/domain/auth_repository.dart';
import 'package:damkina_app/features/onboarding/presentation/onboarding_name_screen.dart';
import 'package:damkina_app/shared/models/app_user.dart';
import 'package:damkina_app/shared/providers/repository_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('prefills onboarding name with Google display name', (
    tester,
  ) async {
    final repository = _TestAuthRepository(
      user: const AppUser(
        id: 'u-1',
        providerId: 'google',
        email: 'user@damkina.test',
        displayName: 'Google Name',
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [authRepositoryProvider.overrideWithValue(repository)],
        child: _TestRouterApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Onboarding name'), findsOneWidget);
    expect(find.text('Google Name'), findsOneWidget);
  });

  testWidgets('saves custom name and goes to onboarding location', (
    tester,
  ) async {
    final repository = _TestAuthRepository(
      user: const AppUser(
        id: 'u-1',
        providerId: 'google',
        email: 'user@damkina.test',
        displayName: 'Google Name',
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [authRepositoryProvider.overrideWithValue(repository)],
        child: _TestRouterApp(),
      ),
    );

    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField), 'Nuevo Nombre');
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();

    expect(repository.lastSavedDisplayName, 'Nuevo Nombre');
    expect(find.text('Onboarding location'), findsOneWidget);
  });
}

class _TestRouterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: AppRoutes.onboardingName,
      routes: [
        GoRoute(
          path: AppRoutes.onboardingName,
          builder: (context, state) => const OnboardingNameScreen(),
        ),
        GoRoute(
          path: AppRoutes.onboardingLocation,
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('Onboarding location'))),
        ),
        GoRoute(
          path: AppRoutes.login,
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('Login route'))),
        ),
      ],
    );

    return MaterialApp.router(routerConfig: router);
  }
}

class _TestAuthRepository implements AuthRepository {
  _TestAuthRepository({required this.user});

  final StreamController<AuthSessionEvent> _controller =
      StreamController<AuthSessionEvent>.broadcast();
  AppUser? user;
  String? lastSavedDisplayName;

  @override
  Stream<AuthSessionEvent> authStateChanges() => _controller.stream;

  @override
  bool get hasActiveSession => user != null;

  @override
  Future<AppUser?> currentUser() async => user;

  @override
  Future<AppUser> saveDisplayName(String displayName) async {
    lastSavedDisplayName = displayName;
    final current = user!;
    final updated = current.copyWith(customName: displayName);
    user = updated;
    _controller.add(AuthSessionEvent.changed);
    return updated;
  }

  @override
  Future<void> signInWithGoogle() async {}

  @override
  Future<AppUser> signInWithDevelopmentAccount() async {
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() async {
    user = null;
    _controller.add(AuthSessionEvent.changed);
  }
}
