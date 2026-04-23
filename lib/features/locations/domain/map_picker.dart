class MapSelection {
  const MapSelection({
    required this.latitude,
    required this.longitude,
    this.altitude,
  });

  final double latitude;
  final double longitude;
  final double? altitude;
}

abstract interface class MapPicker {
  Future<MapSelection?> pickLocation({
    MapSelection? initialSelection,
  });
}
