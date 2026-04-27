abstract interface class LocationSelectionMetadataResolver {
  Future<String?> resolveAddress({
    required double latitude,
    required double longitude,
  });

  Future<double?> resolveAltitude({
    required double latitude,
    required double longitude,
  });
}
