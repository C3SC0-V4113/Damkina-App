import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class AppConfig {
  const AppConfig({
    required this.mapboxAccessToken,
    required this.supabaseUrl,
    required this.supabasePublishableKey,
  });

  factory AppConfig.fromEnvironment() {
    return const AppConfig(
      mapboxAccessToken: String.fromEnvironment('MAPBOX_ACCESS_TOKEN'),
      supabaseUrl: String.fromEnvironment('SUPABASE_URL'),
      supabasePublishableKey: String.fromEnvironment(
        'SUPABASE_PUBLISHABLE_KEY',
      ),
    );
  }

  final String mapboxAccessToken;
  final String supabaseUrl;
  final String supabasePublishableKey;

  bool get hasMapboxAccessToken => mapboxAccessToken.trim().isNotEmpty;
  bool get hasSupabaseConfig =>
      supabaseUrl.trim().isNotEmpty && supabasePublishableKey.trim().isNotEmpty;
  String get googleOAuthRedirectUri => 'damkinaapp://login-callback/';

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
