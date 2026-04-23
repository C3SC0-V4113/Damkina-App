import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_routes.dart';
import '../../../shared/widgets/damkina_placeholder_screen.dart';

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
