import 'package:damkina_app/shared/widgets/damkina_placeholder_screen.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DamkinaPlaceholderScreen(
      title: 'Profile',
      description: 'Profile data will come from AuthRepository.',
    );
  }
}
