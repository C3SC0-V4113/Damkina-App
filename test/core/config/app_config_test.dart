import 'package:damkina_app/core/config/app_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('hasMapboxAccessToken is false when token is empty', () {
    const config = AppConfig(
      mapboxAccessToken: '',
      supabaseUrl: '',
      supabasePublishableKey: '',
    );
    expect(config.hasMapboxAccessToken, isFalse);
  });

  test('hasMapboxAccessToken is true when token is present', () {
    const config = AppConfig(
      mapboxAccessToken: 'pk.test-token',
      supabaseUrl: '',
      supabasePublishableKey: '',
    );
    expect(config.hasMapboxAccessToken, isTrue);
  });
}
