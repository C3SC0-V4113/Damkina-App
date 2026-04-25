import 'package:damkina_app/core/config/app_config.dart';
import 'package:damkina_app/core/routing/router_keys.dart';
import 'package:damkina_app/features/auth/data/fake_auth_repository.dart';
import 'package:damkina_app/features/auth/domain/auth_repository.dart';
import 'package:damkina_app/features/crops/data/fake_crop_repository.dart';
import 'package:damkina_app/features/crops/data/fake_recommendation_repository.dart';
import 'package:damkina_app/features/crops/domain/crop_repository.dart';
import 'package:damkina_app/features/crops/domain/recommendation_repository.dart';
import 'package:damkina_app/features/locations/data/fake_location_repository.dart';
import 'package:damkina_app/features/locations/data/mapbox_map_picker.dart';
import 'package:damkina_app/features/locations/domain/location_repository.dart';
import 'package:damkina_app/features/locations/domain/map_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FakeAuthRepository();
});

final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  return FakeLocationRepository();
});

final mapPickerProvider = Provider<MapPicker>((ref) {
  final appConfig = ref.watch(appConfigProvider);
  return MapboxMapPicker(
    navigatorKey: rootNavigatorKey,
    hasMapboxToken: appConfig.hasMapboxAccessToken,
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
