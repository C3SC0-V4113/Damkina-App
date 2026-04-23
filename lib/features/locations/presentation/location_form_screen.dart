import 'package:flutter/material.dart';

import '../../../shared/widgets/damkina_placeholder_screen.dart';

class LocationFormScreen extends StatelessWidget {
  const LocationFormScreen({
    required this.mode,
    this.locationId,
    super.key,
  });

  final LocationFormMode mode;
  final String? locationId;

  @override
  Widget build(BuildContext context) {
    final title = switch (mode) {
      LocationFormMode.create => 'Add location',
      LocationFormMode.edit => 'Edit location',
    };

    return DamkinaPlaceholderScreen(
      title: title,
      description: 'MapPicker adapter placeholder. Location id: $locationId',
    );
  }
}

enum LocationFormMode {
  create,
  edit,
}
