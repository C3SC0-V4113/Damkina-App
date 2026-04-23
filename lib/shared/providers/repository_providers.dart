import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/data/fake_auth_repository.dart';
import '../../features/auth/domain/auth_repository.dart';
import '../../features/crops/data/fake_crop_repository.dart';
import '../../features/crops/data/fake_recommendation_repository.dart';
import '../../features/crops/domain/crop_repository.dart';
import '../../features/crops/domain/recommendation_repository.dart';
import '../../features/locations/data/fake_location_repository.dart';
import '../../features/locations/data/fake_map_picker.dart';
import '../../features/locations/domain/location_repository.dart';
import '../../features/locations/domain/map_picker.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FakeAuthRepository();
});

final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  return FakeLocationRepository();
});

final mapPickerProvider = Provider<MapPicker>((ref) {
  return FakeMapPicker();
});

final cropRepositoryProvider = Provider<CropRepository>((ref) {
  return FakeCropRepository();
});

final recommendationRepositoryProvider = Provider<RecommendationRepository>((
  ref,
) {
  return FakeRecommendationRepository();
});
