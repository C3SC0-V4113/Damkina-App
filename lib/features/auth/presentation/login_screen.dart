import 'package:damkina_app/core/routing/app_routes.dart';
import 'package:damkina_app/shared/widgets/damkina_placeholder_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DamkinaPlaceholderScreen(
      title: 'Login',
      description: 'Fake/dev auth adapter. Real Google auth needs a later ADR.',
      actionLabel: 'Continue',
      onActionPressed: () => context.go(AppRoutes.onboardingName),
    );
  }
}
