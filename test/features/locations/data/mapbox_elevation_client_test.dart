import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:damkina_app/features/locations/data/mapbox_elevation_client.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MapboxElevationClient', () {
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

    test('returns elevation when contour feature contains ele', () async {
      late Uri capturedUri;
      requestHandler = (request) async {
        capturedUri = request.uri;
        await _writeJsonResponse(
          request: request,
          statusCode: HttpStatus.ok,
          body: const <String, Object>{
            'features': [
              {
                'properties': {'ele': 654},
              },
            ],
          },
        );
      };

      final client = MapboxElevationClient(
        accessToken: 'token-123',
        baseUri: Uri.parse('http://127.0.0.1:${server.port}'),
      );

      final result = await client.resolveAltitude(
        latitude: 13.721,
        longitude: -89.255,
      );

      expect(result, 654);
      expect(
        capturedUri.path,
        '/v4/mapbox.mapbox-terrain-v2/tilequery/-89.255000,13.721000.json',
      );
      expect(capturedUri.queryParameters['access_token'], 'token-123');
      expect(capturedUri.queryParameters['layers'], 'contour');
      expect(capturedUri.queryParameters['limit'], '50');
    });

    test('returns null when features are present but ele is missing', () async {
      requestHandler = (request) async {
        await _writeJsonResponse(
          request: request,
          statusCode: HttpStatus.ok,
          body: const <String, Object>{
            'features': [
              {
                'properties': {'not_ele': 12},
              },
            ],
          },
        );
      };

      final client = MapboxElevationClient(
        accessToken: 'token-123',
        baseUri: Uri.parse('http://127.0.0.1:${server.port}'),
      );

      final result = await client.resolveAltitude(
        latitude: 13.721,
        longitude: -89.255,
      );

      expect(result, isNull);
    });

    test('returns null on non-success status code', () async {
      requestHandler = (request) async {
        await _writeJsonResponse(
          request: request,
          statusCode: HttpStatus.badRequest,
          body: const <String, Object>{'message': 'bad request'},
        );
      };

      final client = MapboxElevationClient(
        accessToken: 'token-123',
        baseUri: Uri.parse('http://127.0.0.1:${server.port}'),
      );

      final result = await client.resolveAltitude(
        latitude: 13.721,
        longitude: -89.255,
      );

      expect(result, isNull);
    });

    test('returns null on invalid payload', () async {
      requestHandler = (request) async {
        request.response.statusCode = HttpStatus.ok;
        request.response.headers.contentType = ContentType.text;
        request.response.write('not-json');
        await request.response.close();
      };

      final client = MapboxElevationClient(
        accessToken: 'token-123',
        baseUri: Uri.parse('http://127.0.0.1:${server.port}'),
      );

      final result = await client.resolveAltitude(
        latitude: 13.721,
        longitude: -89.255,
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
