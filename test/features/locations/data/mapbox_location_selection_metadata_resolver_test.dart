import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:damkina_app/features/locations/data/mapbox_elevation_client.dart';
import 'package:damkina_app/features/locations/data/mapbox_location_selection_metadata_resolver.dart';
import 'package:damkina_app/features/locations/data/mapbox_reverse_geocoding_client.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MapboxLocationSelectionMetadataResolver', () {
    late HttpServer server;
    late StreamSubscription<HttpRequest> subscription;
    late Future<void> Function(HttpRequest request) requestHandler;
    late MapboxReverseGeocodingClient reverseClient;
    late MapboxElevationClient elevationClient;

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

      final baseUri = Uri.parse('http://127.0.0.1:${server.port}');
      reverseClient = MapboxReverseGeocodingClient(
        accessToken: 'token-123',
        baseUri: baseUri,
      );
      elevationClient = MapboxElevationClient(
        accessToken: 'token-123',
        baseUri: baseUri,
      );
    });

    tearDown(() async {
      await subscription.cancel();
      await server.close(force: true);
    });

    test(
      'resolves address and altitude when providers respond successfully',
      () async {
      requestHandler = (request) async {
        if (request.uri.path.contains('/geocoding/v5/mapbox.places/')) {
          await _writeJsonResponse(
            request: request,
            statusCode: HttpStatus.ok,
            body: const <String, Object>{
              'features': [
                {'place_name': 'Avenida Bernal, Cuscatancingo, San Salvador'},
              ],
            },
          );
          return;
        }

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

      final resolver = MapboxLocationSelectionMetadataResolver(
        accessToken: 'token-123',
        reverseGeocodingClient: reverseClient,
        elevationClient: elevationClient,
      );

      final address = await resolver.resolveAddress(
        latitude: 13.721,
        longitude: -89.255,
      );
      final altitude = await resolver.resolveAltitude(
        latitude: 13.721,
        longitude: -89.255,
      );

      expect(address, 'Avenida Bernal, Cuscatancingo');
      expect(altitude, 654);
    });

    test(
      'returns null values and skips requests when access token is empty',
      () async {
      var requestCount = 0;
      requestHandler = (request) async {
        requestCount += 1;
        await _writeJsonResponse(
          request: request,
          statusCode: HttpStatus.ok,
          body: const <String, Object>{'features': []},
        );
      };

      final resolver = MapboxLocationSelectionMetadataResolver(
        accessToken: ' ',
        reverseGeocodingClient: reverseClient,
        elevationClient: elevationClient,
      );

      final address = await resolver.resolveAddress(
        latitude: 13.721,
        longitude: -89.255,
      );
      final altitude = await resolver.resolveAltitude(
        latitude: 13.721,
        longitude: -89.255,
      );

      expect(address, isNull);
      expect(altitude, isNull);
      expect(requestCount, 0);
      },
    );

    test('returns null address on invalid payload', () async {
      requestHandler = (request) async {
        request.response.statusCode = HttpStatus.ok;
        request.response.headers.contentType = ContentType.text;
        request.response.write('not-json');
        await request.response.close();
      };

      final resolver = MapboxLocationSelectionMetadataResolver(
        accessToken: 'token-123',
        reverseGeocodingClient: reverseClient,
        elevationClient: elevationClient,
      );

      final address = await resolver.resolveAddress(
        latitude: 13.721,
        longitude: -89.255,
      );

      expect(address, isNull);
      },
    );

    test('returns null altitude on http error', () async {
      requestHandler = (request) async {
        await _writeJsonResponse(
          request: request,
          statusCode: HttpStatus.badRequest,
          body: const <String, Object>{'message': 'bad request'},
        );
      };

      final resolver = MapboxLocationSelectionMetadataResolver(
        accessToken: 'token-123',
        reverseGeocodingClient: reverseClient,
        elevationClient: elevationClient,
      );

      final altitude = await resolver.resolveAltitude(
        latitude: 13.721,
        longitude: -89.255,
      );

      expect(altitude, isNull);
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
