import 'package:damkina_app/app.dart';
import 'package:damkina_app/core/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appConfig = AppConfig.fromEnvironment()..initializeMapbox();
  if (appConfig.hasSupabaseConfig) {
    await Supabase.initialize(
      url: appConfig.supabaseUrl,
      anonKey: appConfig.supabasePublishableKey,
    );
  }

  runApp(
    ProviderScope(
      overrides: [
        appConfigProvider.overrideWithValue(appConfig),
      ],
      child: const DamkinaApp(),
    ),
  );
}
