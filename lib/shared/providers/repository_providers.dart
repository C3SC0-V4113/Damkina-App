import 'package:damkina_app/core/config/app_config.dart';
import 'package:damkina_app/core/routing/router_keys.dart';
import 'package:damkina_app/features/auth/data/fake_auth_repository.dart';
import 'package:damkina_app/features/auth/data/supabase_auth_repository.dart';
import 'package:damkina_app/features/auth/domain/auth_repository.dart';
import 'package:damkina_app/features/crops/data/fake_crop_repository.dart';
import 'package:damkina_app/features/crops/data/fake_recommendation_repository.dart';
import 'package:damkina_app/features/crops/domain/crop_repository.dart';
import 'package:damkina_app/features/crops/domain/recommendation_repository.dart';
import 'package:damkina_app/features/locations/data/fake_location_repository.dart';
import 'package:damkina_app/features/locations/data/mapbox_location_selection_metadata_resolver.dart';
import 'package:damkina_app/features/locations/data/mapbox_map_picker.dart';
import 'package:damkina_app/features/locations/domain/location_repository.dart';
import 'package:damkina_app/features/locations/domain/location_selection_metadata_resolver.dart';
import 'package:damkina_app/features/locations/domain/map_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final appConfig = ref.watch(appConfigProvider);
  if (appConfig.hasSupabaseConfig) {
    return SupabaseAuthRepository(
      client: Supabase.instance.client,
      appConfig: appConfig,
    );
  }

  return FakeAuthRepository();
});

final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  return FakeLocationRepository();
});

final locationSelectionMetadataResolverProvider =
    Provider<LocationSelectionMetadataResolver?>((ref) {
      final appConfig = ref.watch(appConfigProvider);
      return MapboxLocationSelectionMetadataResolver(
        accessToken: appConfig.mapboxAccessToken,
      );
    });

final mapPickerProvider = Provider<MapPicker>((ref) {
  final appConfig = ref.watch(appConfigProvider);
  final metadataResolver = ref.watch(locationSelectionMetadataResolverProvider);
  return MapboxMapPicker(
    navigatorKey: rootNavigatorKey,
    mapboxAccessToken: appConfig.mapboxAccessToken,
    selectionMetadataResolver: metadataResolver,
  );
});

final cropRepositoryProvider = Provider<CropRepository>((ref) {
  return FakeCropRepository();
});

final recommendationRepositoryProvider = Provider<RecommendationRepository>((
  ref,
) {
  return FakeRecommendationRepository();
});
