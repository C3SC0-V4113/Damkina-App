import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/models/location.dart';
import '../../../shared/providers/repository_providers.dart';

final locationsProvider = FutureProvider<List<Location>>((ref) {
  return ref.watch(locationRepositoryProvider).listLocations();
});

final activeLocationProvider = FutureProvider<Location?>((ref) {
  return ref.watch(locationRepositoryProvider).getActiveLocation();
});

final locationByIdProvider = FutureProvider.family<Location?, String>((ref, id) {
  return ref.watch(locationRepositoryProvider).getLocationById(id);
});
