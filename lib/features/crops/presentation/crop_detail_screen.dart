import 'package:flutter/material.dart';

import '../../../shared/widgets/damkina_placeholder_screen.dart';

class CropDetailScreen extends StatelessWidget {
  const CropDetailScreen({
    required this.cropId,
    super.key,
  });

  final String cropId;

  @override
  Widget build(BuildContext context) {
    return DamkinaPlaceholderScreen(
      title: 'Crop detail',
      description: 'Crop id: $cropId',
    );
  }
}
