import 'dart:async';

import 'package:damkina_app/features/auth/application/auth_providers.dart';
import 'package:damkina_app/features/auth/domain/auth_repository.dart';
import 'package:damkina_app/features/locations/application/location_providers.dart';
import 'package:damkina_app/features/locations/domain/location_repository.dart';
import 'package:damkina_app/shared/models/app_user.dart';
import 'package:damkina_app/shared/models/location.dart';
import 'package:damkina_app/shared/providers/repository_providers.dart';
import 'package:damkina_app/shared/providers/session_reset_coordinator.dart';
import 'package:damkina_app/shared/providers/session_revision_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'session reset bumps revision and recreates user-scoped location state',
    () async {
      final authRepository = _SessionAuthRepository(user: _userA);
      var repositoryInstanceCount = 0;

      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(authRepository),
          locationRepositoryProvider.overrideWith((ref) {
            ref.watch(userSessionRevisionProvider);
            repositoryInstanceCount += 1;
            return _SessionLocationRepository(
              currentUserId: authRepository.user?.id,
              instanceId: repositoryInstanceCount,
            );
          }),
        ],
      );
      addTearDown(container.dispose);

      final authStateSubscription = container.listen<AsyncValue<int>>(
        authStateChangesProvider,
        (previous, next) {
          if (next is AsyncData<int>) {
            container
                .read(sessionResetCoordinatorProvider)
                .resetUserScopedState();
          }
        },
      );
      addTearDown(authStateSubscription.close);

      expect(container.read(userSessionRevisionProvider), 0);

      final repositoryA =
          container.read(locationRepositoryProvider)
              as _SessionLocationRepository;
      final activeLocationA = await container.read(
        activeLocationProvider.future,
      );

      expect(repositoryA.instanceId, 1);
      expect(activeLocationA?.name, 'Ubicacion A');

      authRepository
        ..user = null
        ..emitChanged();
      await container.pump();

      expect(container.read(userSessionRevisionProvider), 1);
      expect(await container.read(activeLocationProvider.future), isNull);

      authRepository
        ..user = _userB
        ..emitChanged();
      await container.pump();

      final repositoryB =
          container.read(locationRepositoryProvider)
              as _SessionLocationRepository;
      final activeLocationB = await container.read(
        activeLocationProvider.future,
      );

      expect(container.read(userSessionRevisionProvider), 2);
      expect(repositoryB.instanceId, 3);
      expect(repositoryB, isNot(same(repositoryA)));
      expect(activeLocationB?.name, 'Ubicacion B');
    },
  );
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

class _SessionAuthRepository implements AuthRepository {
  _SessionAuthRepository({this.user});

  final StreamController<AuthSessionEvent> _controller =
      StreamController<AuthSessionEvent>.broadcast();
  AppUser? user;

  @override
  Stream<AuthSessionEvent> authStateChanges() => _controller.stream;

  void emitChanged() {
    _controller.add(AuthSessionEvent.changed);
  }

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
    user = null;
    emitChanged();
  }
}

class _SessionLocationRepository implements LocationRepository {
  _SessionLocationRepository({
    required this.currentUserId,
    required this.instanceId,
  });

  final String? currentUserId;
  final int instanceId;

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
