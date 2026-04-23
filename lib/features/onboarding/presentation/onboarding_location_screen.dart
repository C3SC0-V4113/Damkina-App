import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_routes.dart';
import '../../../shared/widgets/damkina_placeholder_screen.dart';

class OnboardingLocationScreen extends StatelessWidget {
  const OnboardingLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DamkinaPlaceholderScreen(
      title: 'Onboarding location',
      description: 'Map picker placeholder without a real map SDK.',
      actionLabel: 'View crops',
      onActionPressed: () => context.go(AppRoutes.crops),
    );
  }
}
