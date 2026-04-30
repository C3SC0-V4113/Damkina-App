import 'dart:async';

import 'package:damkina_app/features/auth/application/auth_flow.dart';
import 'package:damkina_app/features/auth/application/auth_providers.dart';
import 'package:damkina_app/features/auth/domain/auth_repository.dart';
import 'package:damkina_app/features/locations/domain/location_repository.dart';
import 'package:damkina_app/shared/models/app_user.dart';
import 'package:damkina_app/shared/models/location.dart';
import 'package:damkina_app/shared/providers/repository_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  test(
    'authRouteStateProvider returns unauthenticated when session is null',
    () async {
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(_AuthRepositoryStub()),
          locationRepositoryProvider.overrideWithValue(
            _LocationRepositoryStub(),
          ),
        ],
      );
      addTearDown(container.dispose);

      final state = await container.read(authRouteStateProvider.future);
      expect(state, AuthRouteState.unauthenticated);
    },
  );

  test(
    'authRouteStateProvider returns needsName for signed user '
    'without customName',
    () async {
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(
            _AuthRepositoryStub(
              user: const AppUser(
                id: 'u1',
                providerId: 'google',
                email: 'user@damkina.test',
                displayName: 'User',
                customName: '',
              ),
              hasActiveSession: true,
            ),
          ),
          locationRepositoryProvider.overrideWithValue(
            _LocationRepositoryStub(hasLocation: true),
          ),
        ],
      );
      addTearDown(container.dispose);

      final state = await container.read(authRouteStateProvider.future);
      expect(state, AuthRouteState.needsName);
    },
  );

  test(
    'authRouteStateProvider returns needsLocation for signed user '
    'without any location',
    () async {
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(
            _AuthRepositoryStub(
              user: const AppUser(
                id: 'u1',
                providerId: 'google',
                email: 'user@damkina.test',
                displayName: 'User',
                customName: 'User',
              ),
              hasActiveSession: true,
            ),
          ),
          locationRepositoryProvider.overrideWithValue(
            _LocationRepositoryStub(),
          ),
        ],
      );
      addTearDown(container.dispose);

      final state = await container.read(authRouteStateProvider.future);
      expect(state, AuthRouteState.needsLocation);
    },
  );

  test(
    'authRouteStateProvider returns authenticated for signed user '
    'with customName and location',
    () async {
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(
            _AuthRepositoryStub(
              user: const AppUser(
                id: 'u1',
                providerId: 'google',
                email: 'user@damkina.test',
                displayName: 'User',
                customName: 'User',
              ),
              hasActiveSession: true,
            ),
          ),
          locationRepositoryProvider.overrideWithValue(
            _LocationRepositoryStub(hasLocation: true),
          ),
        ],
      );
      addTearDown(container.dispose);

      final state = await container.read(authRouteStateProvider.future);
      expect(state, AuthRouteState.authenticated);
    },
  );

  test(
    'authRouteStateProvider keeps loading on transient profile error '
    'with active session',
    () async {
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(
            _AuthRepositoryStub(
              throwOnCurrentUser: true,
              currentUserError: const PostgrestException(
                message: 'JWT expired',
                code: 'PGRST301',
              ),
              hasActiveSession: true,
            ),
          ),
          locationRepositoryProvider.overrideWithValue(
            _LocationRepositoryStub(),
          ),
        ],
      );
      addTearDown(container.dispose);

      final state = await container.read(authRouteStateProvider.future);
      expect(state, AuthRouteState.loading);
    },
  );
}

class _AuthRepositoryStub implements AuthRepository {
  _AuthRepositoryStub({
    this.user,
    this.throwOnCurrentUser = false,
    this.currentUserError,
    this.hasActiveSession = false,
  });

  final StreamController<AuthSessionEvent> _controller =
      StreamController<AuthSessionEvent>.broadcast();
  AppUser? user;
  final bool throwOnCurrentUser;
  final Exception? currentUserError;
  @override
  final bool hasActiveSession;

  @override
  Stream<AuthSessionEvent> authStateChanges() => _controller.stream;

  @override
  Future<AppUser?> currentUser() async {
    if (throwOnCurrentUser) {
      throw currentUserError ?? Exception('transient');
    }
    return user;
  }

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
  Future<void> signOut() async {}
}

class _LocationRepositoryStub implements LocationRepository {
  _LocationRepositoryStub({this.hasLocation = false});

  final bool hasLocation;

  @override
  Future<void> deleteLocation(String id) async {}

  @override
  Future<Location?> getActiveLocation() async => null;

  @override
  Future<Location?> getLocationById(String id) async => null;

  @override
  Future<bool> hasAnyLocationForUser(String userId) async => hasLocation;

  @override
  Future<List<Location>> listLocations() async => const [];

  @override
  Future<Location> saveLocation(Location location) async => location;

  @override
  Future<void> setActiveLocation(String id) async {}
}
