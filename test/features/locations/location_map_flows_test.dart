import 'package:damkina_app/app.dart';
import 'package:damkina_app/core/routing/app_router.dart';
import 'package:damkina_app/features/auth/application/auth_flow.dart';
import 'package:damkina_app/features/auth/application/auth_providers.dart';
import 'package:damkina_app/features/auth/domain/auth_repository.dart';
import 'package:damkina_app/features/locations/domain/map_picker.dart';
import 'package:damkina_app/features/locations/presentation/mapbox_location_picker_screen.dart';
import 'package:damkina_app/shared/models/app_user.dart';
import 'package:damkina_app/shared/providers/repository_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('map picker shows recoverable UI when token is missing', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MapboxLocationPickerScreen(hasMapboxToken: false),
      ),
    );

    expect(find.text('Mapbox token is missing.'), findsOneWidget);
    expect(find.text('Close'), findsOneWidget);
  });

  testWidgets('onboarding location creates and activates first location', (
    tester,
  ) async {
    const selection = MapSelection(
      latitude: 13.721,
      longitude: -89.255,
      altitude: 700,
    );
    final routeState = _RouteStateController(AuthRouteState.needsLocation);
    final container = await _pumpApp(
      tester,
      mapPicker: const _TestMapPicker(selection),
      routeState: routeState,
    );
    final router = container.read(appRouterProvider);

    await _goAndPump(router, tester, '/onboarding/location');

    await tester.enterText(find.byType(TextFormField), 'Parcela Uno');
    await tester.tap(find.text('Seleccionar en mapa'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Guardar y ver cultivos'));
    await tester.tap(find.text('Guardar y ver cultivos'));
    routeState.value = AuthRouteState.authenticated;
    await tester.pumpAndSettle();

    final repository = container.read(locationRepositoryProvider);
    final locations = await repository.listLocations();
    final active = await repository.getActiveLocation();

    expect(locations.any((location) => location.name == 'Parcela Uno'), isTrue);
    expect(active?.name, 'Parcela Uno');
  });

  testWidgets('locations new flow saves a location from map picker', (
    tester,
  ) async {
    const selection = MapSelection(
      latitude: 13.745,
      longitude: -89.301,
      altitude: 715,
    );
    final container = await _pumpApp(
      tester,
      mapPicker: const _TestMapPicker(selection),
      routeState: _RouteStateController(AuthRouteState.authenticated),
    );
    final router = container.read(appRouterProvider);

    await _goAndPump(router, tester, '/locations/new');

    await tester.enterText(find.byType(TextFormField), 'Finca Test');
    await tester.tap(find.text('Select on map'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create location'));
    await tester.pumpAndSettle();

    expect(find.text('Locations'), findsWidgets);
    expect(find.text('Finca Test'), findsOneWidget);
  });

  testWidgets('locations edit flow updates name and coordinates', (
    tester,
  ) async {
    const selection = MapSelection(
      latitude: 13.8,
      longitude: -89.4,
      altitude: 810,
    );
    final container = await _pumpApp(
      tester,
      mapPicker: const _TestMapPicker(selection),
      routeState: _RouteStateController(AuthRouteState.authenticated),
    );
    final router = container.read(appRouterProvider);

    await _goAndPump(router, tester, '/locations/location-juayua/edit');

    await tester.enterText(find.byType(TextFormField), 'Terreno Central');
    await tester.tap(find.text('Update map selection'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();

    final repository = container.read(locationRepositoryProvider);
    final updated = await repository.getLocationById('location-juayua');

    expect(updated, isNotNull);
    expect(updated!.name, 'Terreno Central');
    expect(updated.latitude, closeTo(selection.latitude, 0.000001));
    expect(updated.longitude, closeTo(selection.longitude, 0.000001));
  });
}

Future<ProviderContainer> _pumpApp(
  WidgetTester tester, {
  required MapPicker mapPicker,
  required _RouteStateController routeState,
}) async {
  final container = ProviderContainer(
    overrides: [
      mapPickerProvider.overrideWithValue(mapPicker),
      authRepositoryProvider.overrideWithValue(_SignedInAuthRepository()),
      authRouteStateProvider.overrideWith((ref) async => routeState.value),
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
  return container;
}

Future<void> _goAndPump(
  GoRouter router,
  WidgetTester tester,
  String route,
) async {
  router.go(route);
  await tester.pumpAndSettle();
}

class _TestMapPicker implements MapPicker {
  const _TestMapPicker(this._selection);

  final MapSelection _selection;

  @override
  Future<MapSelection?> pickLocation({
    MapSelection? initialSelection,
  }) async {
    return _selection;
  }
}

class _RouteStateController {
  _RouteStateController(this.value);

  AuthRouteState value;
}

class _SignedInAuthRepository implements AuthRepository {
  final AppUser _user = const AppUser(
    id: 'user-dev-001',
    providerId: 'fake-dev',
    email: 'dev@damkina.local',
    displayName: 'Damkina Dev',
    customName: 'Damkina Dev',
  );

  @override
  Stream<AuthSessionEvent> authStateChanges() => const Stream.empty();

  @override
  bool get hasActiveSession => true;

  @override
  Future<AppUser?> currentUser() async => _user;

  @override
  Future<AppUser> saveDisplayName(String displayName) async {
    return _user.copyWith(customName: displayName);
  }

  @override
  Future<void> signInWithGoogle() async {}

  @override
  Future<AppUser> signInWithDevelopmentAccount() async => _user;

  @override
  Future<void> signOut() async {}
}
