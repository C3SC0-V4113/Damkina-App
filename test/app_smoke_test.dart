import 'package:damkina_app/app.dart';
import 'package:damkina_app/core/routing/app_router.dart';
import 'package:damkina_app/shared/providers/repository_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('app starts at login route', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: DamkinaApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Login'), findsWidgets);
  });

  testWidgets('router can navigate to initial MVP routes', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final router = container.read(appRouterProvider);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const DamkinaApp(),
      ),
    );

    for (final route in [
      '/onboarding/name',
      '/onboarding/location',
      '/crops',
      '/crops/crop-tomato',
      '/locations',
      '/locations/new',
      '/locations/location-juayua/edit',
      '/profile',
    ]) {
      router.go(route);
      await tester.pumpAndSettle();
      expect(find.byType(Scaffold), findsWidgets);
    }
  });

  test('fake repositories return deterministic local data', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final locations = await container
        .read(locationRepositoryProvider)
        .listLocations();
    final crops = await container.read(cropRepositoryProvider).listCrops();
    final recommendations = await container
        .read(recommendationRepositoryProvider)
        .listRecommendationsForLocation('location-juayua');

    expect(locations, isNotEmpty);
    expect(crops, isNotEmpty);
    expect(recommendations, isNotEmpty);
  });
}
