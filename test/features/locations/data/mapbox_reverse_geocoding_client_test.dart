import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:damkina_app/features/locations/data/mapbox_reverse_geocoding_client.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MapboxReverseGeocodingClient', () {
    late HttpServer server;
    late StreamSubscription<HttpRequest> subscription;
    late Future<void> Function(HttpRequest request) requestHandler;

    setUp(() async {
      server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      requestHandler = (request) async {
        await _writeJsonResponse(
          request: request,
          statusCode: HttpStatus.ok,
          body: const <String, Object>{'features': []},
        );
      };
      subscription = server.listen((request) async {
        await requestHandler(request);
      });
    });

    tearDown(() async {
      await subscription.cancel();
      await server.close(force: true);
    });

    test('returns place_name when API responds with a feature', () async {
      late Uri capturedUri;
      requestHandler = (request) async {
        capturedUri = request.uri;
        await _writeJsonResponse(
          request: request,
          statusCode: HttpStatus.ok,
          body: const <String, Object>{
            'features': [
              {'place_name': 'San Salvador, El Salvador'},
            ],
          },
        );
      };

      final client = MapboxReverseGeocodingClient(
        accessToken: 'token-123',
        baseUri: Uri.parse('http://127.0.0.1:${server.port}'),
      );

      final result = await client.reverseGeocode(
        latitude: 13.721,
        longitude: -89.255,
      );

      expect(result, 'San Salvador, El Salvador');
      expect(
        capturedUri.path,
        '/geocoding/v5/mapbox.places/-89.255000,13.721000.json',
      );
      expect(capturedUri.queryParameters['access_token'], 'token-123');
      expect(capturedUri.queryParameters['limit'], '1');
      expect(capturedUri.queryParameters['language'], 'en');
    });

    test('returns null when API responds with empty features', () async {
      final client = MapboxReverseGeocodingClient(
        accessToken: 'token-123',
        baseUri: Uri.parse('http://127.0.0.1:${server.port}'),
      );

      final result = await client.reverseGeocode(
        latitude: 13.7,
        longitude: -89.2,
      );

      expect(result, isNull);
    });

    test('returns null when API responds with non-success status', () async {
      requestHandler = (request) async {
        await _writeJsonResponse(
          request: request,
          statusCode: HttpStatus.badRequest,
          body: const <String, Object>{'message': 'bad request'},
        );
      };

      final client = MapboxReverseGeocodingClient(
        accessToken: 'token-123',
        baseUri: Uri.parse('http://127.0.0.1:${server.port}'),
      );

      final result = await client.reverseGeocode(
        latitude: 13.7,
        longitude: -89.2,
      );

      expect(result, isNull);
    });

    test('returns null when API responds with invalid payload', () async {
      requestHandler = (request) async {
        request.response.statusCode = HttpStatus.ok;
        request.response.headers.contentType = ContentType.text;
        request.response.write('not-json');
        await request.response.close();
      };

      final client = MapboxReverseGeocodingClient(
        accessToken: 'token-123',
        baseUri: Uri.parse('http://127.0.0.1:${server.port}'),
      );

      final result = await client.reverseGeocode(
        latitude: 13.7,
        longitude: -89.2,
      );

      expect(result, isNull);
    });
  });
}

Future<void> _writeJsonResponse({
  required HttpRequest request,
  required int statusCode,
  required Object body,
}) async {
  request.response.statusCode = statusCode;
  request.response.headers.contentType = ContentType.json;
  request.response.write(jsonEncode(body));
  await request.response.close();
}
