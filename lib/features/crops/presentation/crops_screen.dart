import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/damkina_placeholder_screen.dart';

class CropsScreen extends StatelessWidget {
  const CropsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DamkinaPlaceholderScreen(
      title: 'Crops',
      description: 'Recommendations will read AsyncValue from Riverpod.',
      actionLabel: 'Open sample crop',
      onActionPressed: () => context.go('/crops/crop-tomato'),
    );
  }
}
