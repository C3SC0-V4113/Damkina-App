import 'package:damkina_app/features/locations/data/mapbox_elevation_client.dart';
import 'package:damkina_app/features/locations/data/mapbox_reverse_geocoding_client.dart';
import 'package:damkina_app/features/locations/domain/location_selection_metadata_resolver.dart';

class MapboxLocationSelectionMetadataResolver
    implements LocationSelectionMetadataResolver {
  MapboxLocationSelectionMetadataResolver({
    required String accessToken,
    MapboxReverseGeocodingClient? reverseGeocodingClient,
    MapboxElevationClient? elevationClient,
  }) : _reverseGeocodingClient = accessToken.trim().isEmpty
           ? null
           : reverseGeocodingClient ??
                 MapboxReverseGeocodingClient(accessToken: accessToken),
       _elevationClient = accessToken.trim().isEmpty
           ? null
           : elevationClient ?? MapboxElevationClient(accessToken: accessToken);

  final MapboxReverseGeocodingClient? _reverseGeocodingClient;
  final MapboxElevationClient? _elevationClient;

  @override
  Future<String?> resolveAddress({
    required double latitude,
    required double longitude,
  }) async {
    final client = _reverseGeocodingClient;
    if (client == null) {
      return null;
    }

    return client.reverseGeocode(
      latitude: latitude,
      longitude: longitude,
    );
  }

  @override
  Future<double?> resolveAltitude({
    required double latitude,
    required double longitude,
  }) async {
    final client = _elevationClient;
    if (client == null) {
      return null;
    }

    return client.resolveAltitude(
      latitude: latitude,
      longitude: longitude,
    );
  }
}
