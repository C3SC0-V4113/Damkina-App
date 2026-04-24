import 'package:damkina_app/shared/models/crop.dart';
import 'package:damkina_app/shared/models/recommendation.dart';
import 'package:damkina_app/shared/providers/repository_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
