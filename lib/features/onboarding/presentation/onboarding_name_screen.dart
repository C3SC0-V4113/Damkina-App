import 'package:damkina_app/core/routing/app_routes.dart';
import 'package:damkina_app/shared/widgets/damkina_placeholder_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
