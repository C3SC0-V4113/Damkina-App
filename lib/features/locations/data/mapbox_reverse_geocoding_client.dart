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
  static const _maxAddressLength = 40;

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
        return _shortAddressFromPlaceName(placeName);
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

  String? _shortAddressFromPlaceName(String placeName) {
    final normalized = placeName
        .split(',')
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty)
        .toList();
    if (normalized.isEmpty) {
      return null;
    }

    final street = normalized.first;
    final city = normalized
        .skip(1)
        .firstWhere(
          (segment) => segment.toLowerCase() != street.toLowerCase(),
          orElse: () => '',
        );

    final shortAddress = city.isEmpty ? street : '$street, $city';
    return _truncateAddress(shortAddress);
  }

  String _truncateAddress(String value) {
    if (value.length <= _maxAddressLength) {
      return value;
    }

    const ellipsis = '...';
    const minTrimmedLength = 16;
    const maxWithoutEllipsis = _maxAddressLength - 3;
    final head = value.substring(0, maxWithoutEllipsis + 1);
    final lastSpace = head.lastIndexOf(' ');
    final cutoff = lastSpace >= minTrimmedLength
        ? lastSpace
        : maxWithoutEllipsis;
    final trimmed = value.substring(0, cutoff).trimRight();
    return '$trimmed$ellipsis';
  }
}
