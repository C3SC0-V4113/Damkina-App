import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/models/crop.dart';
import '../../../shared/models/recommendation.dart';
import '../../../shared/providers/repository_providers.dart';

final cropsProvider = FutureProvider<List<Crop>>((ref) {
  return ref.watch(cropRepositoryProvider).listCrops();
});

final cropByIdProvider = FutureProvider.family<Crop?, String>((ref, id) {
  return ref.watch(cropRepositoryProvider).getCropById(id);
});

final recommendationsForLocationProvider =
    FutureProvider.family<List<Recommendation>, String>((ref, locationId) {
  return ref
      .watch(recommendationRepositoryProvider)
      .listRecommendationsForLocation(locationId);
});
