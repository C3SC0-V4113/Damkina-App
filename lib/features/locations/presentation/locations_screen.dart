import 'package:damkina_app/core/routing/app_routes.dart';
import 'package:damkina_app/shared/widgets/damkina_placeholder_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LocationsScreen extends StatelessWidget {
  const LocationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DamkinaPlaceholderScreen(
      title: 'Locations',
      description: 'Saved locations will read from LocationRepository.',
      actionLabel: 'Add location',
      onActionPressed: () => context.go(AppRoutes.locationNew),
    );
  }
}
