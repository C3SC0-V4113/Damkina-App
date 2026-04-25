import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class AppConfig {
  const AppConfig({
    required this.mapboxAccessToken,
  });

  factory AppConfig.fromEnvironment() {
    return const AppConfig(
      mapboxAccessToken: String.fromEnvironment('MAPBOX_ACCESS_TOKEN'),
    );
  }

  final String mapboxAccessToken;

  bool get hasMapboxAccessToken => mapboxAccessToken.trim().isNotEmpty;

  void initializeMapbox() {
    if (!hasMapboxAccessToken) {
      return;
    }

    MapboxOptions.setAccessToken(mapboxAccessToken);
  }
}

final appConfigProvider = Provider<AppConfig>((ref) {
  return AppConfig.fromEnvironment();
});
