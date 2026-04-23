import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_routes.dart';
import '../../../shared/widgets/damkina_placeholder_screen.dart';

class OnboardingNameScreen extends StatelessWidget {
  const OnboardingNameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DamkinaPlaceholderScreen(
      title: 'Onboarding name',
      description: 'Name confirmation placeholder for the MVP flow.',
      actionLabel: 'Continue',
      onActionPressed: () => context.go(AppRoutes.onboardingLocation),
    );
  }
}
