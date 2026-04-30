import 'package:damkina_app/shared/models/location.dart';
import 'package:damkina_app/shared/providers/repository_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final locationsProvider = FutureProvider<List<Location>>((ref) {
  return ref.watch(locationRepositoryProvider).listLocations();
});

final activeLocationProvider = FutureProvider<Location?>((ref) {
  return ref.watch(locationRepositoryProvider).getActiveLocation();
});

final locationByIdProvider = FutureProvider.family<Location?, String>((
  ref,
  id,
) {
  return ref.watch(locationRepositoryProvider).getLocationById(id);
});

final locationAddressProvider =
    FutureProvider.family<String?, (double latitude, double longitude)>((
      ref,
      coordinates,
    ) async {
      final resolver = ref.watch(locationSelectionMetadataResolverProvider);
      if (resolver == null) {
        return null;
      }

      return resolver.resolveAddress(
        latitude: coordinates.$1,
        longitude: coordinates.$2,
      );
    });
