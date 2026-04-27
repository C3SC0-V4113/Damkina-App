import 'package:damkina_app/features/locations/data/mapbox_reverse_geocoding_client.dart';
import 'package:damkina_app/features/locations/domain/map_picker.dart';
import 'package:damkina_app/features/locations/presentation/mapbox_location_picker_screen.dart';
import 'package:flutter/material.dart';

class MapboxMapPicker implements MapPicker {
  MapboxMapPicker({
    required GlobalKey<NavigatorState> navigatorKey,
    required String mapboxAccessToken,
  }) : _navigatorKey = navigatorKey,
       _mapboxAccessToken = mapboxAccessToken,
       _reverseGeocodingClient = mapboxAccessToken.trim().isEmpty
           ? null
           : MapboxReverseGeocodingClient(accessToken: mapboxAccessToken);

  final GlobalKey<NavigatorState> _navigatorKey;
  final String _mapboxAccessToken;
  final MapboxReverseGeocodingClient? _reverseGeocodingClient;

  bool get _hasMapboxToken => _mapboxAccessToken.trim().isNotEmpty;

  @override
  Future<MapSelection?> pickLocation({
    MapSelection? initialSelection,
  }) async {
    final navigator = _navigatorKey.currentState;
    final context = _navigatorKey.currentContext;
    if (navigator == null || context == null) {
      return null;
    }

    return navigator.push<MapSelection>(
      MaterialPageRoute(
        builder: (_) => MapboxLocationPickerScreen(
          initialSelection: initialSelection,
          hasMapboxToken: _hasMapboxToken,
          resolveAddress: _reverseGeocodingClient?.reverseGeocode,
        ),
      ),
    );
  }
}
