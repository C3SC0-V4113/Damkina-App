import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_routes.dart';
import '../../../shared/widgets/damkina_placeholder_screen.dart';

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
