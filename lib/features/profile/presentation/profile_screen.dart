import 'package:flutter/material.dart';

import '../../../shared/widgets/damkina_placeholder_screen.dart';

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
