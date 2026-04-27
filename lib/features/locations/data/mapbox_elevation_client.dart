import 'dart:convert';
import 'dart:io';

class MapboxElevationClient {
  MapboxElevationClient({
    required String accessToken,
    Uri? baseUri,
    HttpClient? httpClient,
  }) : _accessToken = accessToken,
       _baseUri = baseUri ?? Uri(scheme: 'https', host: 'api.mapbox.com'),
       _httpClient = httpClient ?? HttpClient();

  final String _accessToken;
  final Uri _baseUri;
  final HttpClient _httpClient;

  Future<double?> resolveAltitude({
    required double latitude,
    required double longitude,
  }) async {
    if (_accessToken.trim().isEmpty) {
      return null;
    }

    final uri = _buildTileQueryUri(
      latitude: latitude,
      longitude: longitude,
    );

    try {
      final request = await _httpClient.getUrl(uri);
      final response = await request.close();
      if (response.statusCode != HttpStatus.ok) {
        return null;
      }

      final payload = await response.transform(utf8.decoder).join();
      final decoded = jsonDecode(payload);
      if (decoded is! Map<String, dynamic>) {
        return null;
      }

      final features = decoded['features'];
      if (features is! List || features.isEmpty) {
        return null;
      }

      for (final feature in features) {
        if (feature is! Map<String, dynamic>) {
          continue;
        }
        final properties = feature['properties'];
        if (properties is! Map<String, dynamic>) {
          continue;
        }
        final elevation = properties['ele'];
        if (elevation is num) {
          return elevation.toDouble();
        }
      }

      return null;
    } on Exception {
      return null;
    }
  }

  Uri _buildTileQueryUri({
    required double latitude,
    required double longitude,
  }) {
    final coordinates =
        '${longitude.toStringAsFixed(6)},${latitude.toStringAsFixed(6)}';
    final basePath = _baseUri.path.endsWith('/')
        ? _baseUri.path.substring(0, _baseUri.path.length - 1)
        : _baseUri.path;
    final path =
        '$basePath/v4/mapbox.mapbox-terrain-v2/tilequery/$coordinates.json';

    return _baseUri.replace(
      path: path.isEmpty ? '/' : path,
      queryParameters: {
        'access_token': _accessToken,
        'layers': 'contour',
        'limit': '50',
      },
    );
  }
}
