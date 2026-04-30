import 'dart:async';

import 'package:damkina_app/core/theme/app_theme.dart';
import 'package:damkina_app/features/auth/domain/auth_repository.dart';
import 'package:damkina_app/features/locations/domain/location_repository.dart';
import 'package:damkina_app/features/profile/presentation/profile_screen.dart';
import 'package:damkina_app/shared/models/app_user.dart';
import 'package:damkina_app/shared/models/location.dart';
import 'package:damkina_app/shared/providers/repository_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'renders user data, active location and member since '
    'with avatar placeholder',
    (tester) async {
      final authRepository = _ProfileAuthRepository(
        user: AppUser(
          id: 'user-1',
          providerId: 'google',
          email: 'river@example.com',
          displayName: 'River Google',
          customName: 'River',
          createdAt: DateTime.utc(2024, 3, 10),
        ),
      );
      final locationRepository = _ProfileLocationRepository(
        activeLocation: Location(
          id: 'loc-1',
          userId: 'user-1',
          name: 'Portland, OR',
          latitude: 0,
          longitude: 0,
          altitude: 0,
          koppenClassification: 'Csb',
          climateSummary: 'templado',
          seasonalitySummary: 'suave',
          currentSeason: 'Primavera',
          createdAt: DateTime.utc(2024, 3, 12),
        ),
      );

      await tester.pumpWidget(
        _ProfileTestApp(
          authRepository: authRepository,
          locationRepository: locationRepository,
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Perfil'), findsOneWidget);
      expect(find.text('River'), findsOneWidget);
      expect(find.text('river@example.com'), findsOneWidget);
      expect(find.text('Portland, OR'), findsOneWidget);
      expect(find.text('Marzo 2024'), findsOneWidget);
      expect(find.byIcon(Icons.person_rounded), findsOneWidget);
    },
  );

  testWidgets('opens sign out sheet and signs out after confirmation', (
    tester,
  ) async {
    final authRepository = _ProfileAuthRepository(
      user: const AppUser(
        id: 'user-1',
        providerId: 'google',
        email: 'river@example.com',
        displayName: 'River',
        customName: 'River',
      ),
    );

    await tester.pumpWidget(
      _ProfileTestApp(
        authRepository: authRepository,
        locationRepository: const _ProfileLocationRepository(
          activeLocation: null,
        ),
      ),
    );

    await tester.pumpAndSettle();

    final signOutAction = find.textContaining('Cerrar sesi');
    await tester.ensureVisible(signOutAction);
    await tester.tap(signOutAction);
    await tester.pumpAndSettle();

    expect(find.textContaining('volver a iniciar sesión'), findsOneWidget);

    final confirmButton = find.byWidgetPredicate(
      (widget) =>
          widget is FilledButton &&
          widget.child is Text &&
          (widget.child! as Text).data == 'Cerrar sesión',
    );
    await tester.tap(confirmButton);
    await tester.pumpAndSettle();

    expect(authRepository.signOutCalls, 1);
    expect(await authRepository.currentUser(), isNull);
  });
}

class _ProfileTestApp extends StatelessWidget {
  const _ProfileTestApp({
    required this.authRepository,
    required this.locationRepository,
  });

  final AuthRepository authRepository;
  final LocationRepository locationRepository;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(authRepository),
        locationRepositoryProvider.overrideWithValue(locationRepository),
      ],
      child: MaterialApp(
        theme: AppTheme.light(),
        home: const ProfileScreen(),
      ),
    );
  }
}

class _ProfileAuthRepository implements AuthRepository {
  _ProfileAuthRepository({this.user});

  final StreamController<AuthSessionEvent> _controller =
      StreamController<AuthSessionEvent>.broadcast();
  AppUser? user;
  int signOutCalls = 0;

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
  Future<void> signInWithGoogle() async {}

  @override
  Future<AppUser> signInWithDevelopmentAccount() async {
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() async {
    signOutCalls += 1;
    user = null;
    _controller.add(AuthSessionEvent.changed);
  }
}

class _ProfileLocationRepository implements LocationRepository {
  const _ProfileLocationRepository({required this.activeLocation});

  final Location? activeLocation;

  @override
  Future<void> deleteLocation(String id) async {}

  @override
  Future<Location?> getActiveLocation() async => activeLocation;

  @override
  Future<Location?> getLocationById(String id) async => activeLocation;

  @override
  Future<bool> hasAnyLocationForUser(String userId) async =>
      activeLocation != null;

  @override
  Future<List<Location>> listLocations() async =>
      activeLocation == null ? const [] : [activeLocation!];

  @override
  Future<Location> saveLocation(Location location) async => location;

  @override
  Future<void> setActiveLocation(String id) async {}
}
