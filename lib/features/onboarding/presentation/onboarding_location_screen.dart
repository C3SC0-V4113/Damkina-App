import 'package:damkina_app/core/routing/app_routes.dart';
import 'package:damkina_app/shared/widgets/damkina_placeholder_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
