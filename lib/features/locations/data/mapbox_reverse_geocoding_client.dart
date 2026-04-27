import 'dart:convert';
import 'dart:io';

class MapboxReverseGeocodingClient {
  MapboxReverseGeocodingClient({
    required String accessToken,
    Uri? baseUri,
    HttpClient? httpClient,
  }) : _accessToken = accessToken,
       _baseUri = baseUri ?? Uri(scheme: 'https', host: 'api.mapbox.com'),
       _httpClient = httpClient ?? HttpClient();

  final String _accessToken;
  final Uri _baseUri;
  final HttpClient _httpClient;

  Future<String?> reverseGeocode({
    required double latitude,
    required double longitude,
  }) async {
    if (_accessToken.trim().isEmpty) {
      return null;
    }

    final uri = _buildReverseUri(
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

      final first = features.first;
      if (first is! Map<String, dynamic>) {
        return null;
      }

      final placeName = first['place_name'];
      if (placeName is String && placeName.trim().isNotEmpty) {
        return placeName.trim();
      }

      return null;
    } on Exception {
      return null;
    }
  }

  Uri _buildReverseUri({
    required double latitude,
    required double longitude,
  }) {
    final coordinates =
        '${longitude.toStringAsFixed(6)},${latitude.toStringAsFixed(6)}';
    final basePath = _baseUri.path.endsWith('/')
        ? _baseUri.path.substring(0, _baseUri.path.length - 1)
        : _baseUri.path;
    final path = '$basePath/geocoding/v5/mapbox.places/$coordinates.json';

    return _baseUri.replace(
      path: path.isEmpty ? '/' : path,
      queryParameters: {
        'access_token': _accessToken,
        'limit': '1',
        'language': 'en',
      },
    );
  }
}
