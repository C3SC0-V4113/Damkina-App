import 'dart:async';

import 'package:damkina_app/app.dart';
import 'package:damkina_app/core/routing/app_router.dart';
import 'package:damkina_app/features/auth/domain/auth_repository.dart';
import 'package:damkina_app/features/locations/domain/location_repository.dart';
import 'package:damkina_app/shared/models/app_user.dart';
import 'package:damkina_app/shared/models/location.dart';
import 'package:damkina_app/shared/providers/repository_providers.dart';
import 'package:damkina_app/shared/providers/session_revision_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets(
    'profile and locations do not reuse another user session state '
    'after re-login',
    (tester) async {
      final authRepository = _FlowAuthRepository(user: _userA);

      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(authRepository),
          locationRepositoryProvider.overrideWith((ref) {
            ref.watch(userSessionRevisionProvider);
            return _FlowLocationRepository(
              currentUserId: authRepository.user?.id,
            );
          }),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const DamkinaApp(),
        ),
      );
      await tester.pumpAndSettle();

      final router = container.read(appRouterProvider);
      await _goAndPump(router, tester, '/profile');

      expect(find.text('Usuario A'), findsOneWidget);
      expect(find.text('Ubicacion A'), findsOneWidget);

      final signOutAction = find.textContaining('Cerrar sesi');
      await tester.ensureVisible(signOutAction);
      await tester.tap(signOutAction);
      await tester.pumpAndSettle();

      final confirmButton = find.byWidgetPredicate(
        (widget) =>
            widget is FilledButton &&
            widget.child is Text &&
            ((widget.child! as Text).data ?? '').contains('Cerrar sesi'),
      );
      await tester.tap(confirmButton);
      await tester.pumpAndSettle();

      expect(find.text('Bienvenido'), findsOneWidget);

      await tester.tap(find.text('Continue with Google'));
      await tester.pumpAndSettle();

      await _goAndPump(router, tester, '/profile');

      expect(find.text('Usuario B'), findsOneWidget);
      expect(find.text('Ubicacion B'), findsOneWidget);
      expect(find.text('Ubicacion A'), findsNothing);
    },
  );
}

Future<void> _goAndPump(
  GoRouter router,
  WidgetTester tester,
  String route,
) async {
  router.go(route);
  await tester.pumpAndSettle();
}

const _userA = AppUser(
  id: 'user-a',
  providerId: 'google',
  email: 'a@damkina.test',
  displayName: 'Usuario A',
  customName: 'Usuario A',
);

const _userB = AppUser(
  id: 'user-b',
  providerId: 'google',
  email: 'b@damkina.test',
  displayName: 'Usuario B',
  customName: 'Usuario B',
);

class _FlowAuthRepository implements AuthRepository {
  _FlowAuthRepository({this.user});

  final StreamController<AuthSessionEvent> _controller =
      StreamController<AuthSessionEvent>.broadcast();
  AppUser? user;

  @override
  Stream<AuthSessionEvent> authStateChanges() => _controller.stream;

  @override
  bool get hasActiveSession => user != null;

  @override
  Future<AppUser?> currentUser() async => user;

  @override
  Future<AppUser> saveDisplayName(String displayName) async {
    throw UnimplementedError();
  }

  @override
  Future<void> signInWithGoogle() async {
    user = _userB;
    _controller.add(AuthSessionEvent.changed);
  }

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

class _FlowLocationRepository implements LocationRepository {
  const _FlowLocationRepository({required this.currentUserId});

  final String? currentUserId;

  @override
  Future<void> deleteLocation(String id) async {}

  @override
  Future<Location?> getActiveLocation() async {
    return switch (currentUserId) {
      'user-a' => _locationA,
      'user-b' => _locationB,
      _ => null,
    };
  }

  @override
  Future<Location?> getLocationById(String id) async {
    final active = await getActiveLocation();
    return active?.id == id ? active : null;
  }

  @override
  Future<bool> hasAnyLocationForUser(String userId) async {
    return userId == 'user-a' || userId == 'user-b';
  }

  @override
  Future<List<Location>> listLocations() async {
    final active = await getActiveLocation();
    return active == null ? const [] : [active];
  }

  @override
  Future<Location> saveLocation(Location location) async => location;

  @override
  Future<void> setActiveLocation(String id) async {}
}

final _locationA = Location(
  id: 'location-a',
  userId: 'user-a',
  name: 'Ubicacion A',
  latitude: 13,
  longitude: -89,
  altitude: 500,
  koppenClassification: 'Aw',
  climateSummary: 'Calido',
  seasonalitySummary: 'Seco',
  currentSeason: 'Verano',
  createdAt: DateTime.utc(2026, 4, 21),
);

final _locationB = Location(
  id: 'location-b',
  userId: 'user-b',
  name: 'Ubicacion B',
  latitude: 14,
  longitude: -88,
  altitude: 900,
  koppenClassification: 'Cwb',
  climateSummary: 'Templado',
  seasonalitySummary: 'Lluvioso',
  currentSeason: 'Invierno',
  createdAt: DateTime.utc(2026, 4, 22),
);
