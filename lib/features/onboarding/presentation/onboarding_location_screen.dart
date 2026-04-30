import 'package:damkina_app/core/routing/app_routes.dart';
import 'package:damkina_app/core/theme/app_tokens.dart';
import 'package:damkina_app/features/auth/application/auth_providers.dart';
import 'package:damkina_app/features/locations/application/location_draft_factory.dart';
import 'package:damkina_app/features/locations/application/location_providers.dart';
import 'package:damkina_app/features/locations/domain/map_picker.dart';
import 'package:damkina_app/shared/providers/repository_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OnboardingLocationScreen extends ConsumerStatefulWidget {
  const OnboardingLocationScreen({super.key});

  @override
  ConsumerState<OnboardingLocationScreen> createState() =>
      _OnboardingLocationScreenState();
}

class _OnboardingLocationScreenState
    extends ConsumerState<OnboardingLocationScreen> {
  final _nameController = TextEditingController(text: 'My first location');
  final _formKey = GlobalKey<FormState>();
  MapSelection? _selection;
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Onboarding location')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Select your first location',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: AppSpacing.sm),
                const Text(
                  'Pick a point on the map and save it as your active '
                  'location.',
                ),
                const SizedBox(height: AppSpacing.lg),
                TextFormField(
                  controller: _nameController,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    labelText: 'Location name',
                    hintText: 'Casa, Parcela Norte, Terreno de Juayua...',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Location name is required.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                OutlinedButton.icon(
                  onPressed: _saving ? null : _pickFromMap,
                  icon: const Icon(Icons.map_outlined),
                  label: Text(
                    _selection == null
                        ? 'Select on map'
                        : 'Update map selection',
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  _selection == null
                      ? 'No location selected yet.'
                      : 'Lat ${_selection!.latitude.toStringAsFixed(5)} - '
                            'Lng ${_selection!.longitude.toStringAsFixed(5)}',
                ),
                const SizedBox(height: AppSpacing.xl),
                FilledButton(
                  onPressed: _saving ? null : _saveAndContinue,
                  child: _saving
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save and view crops'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickFromMap() async {
    final selection = await ref
        .read(mapPickerProvider)
        .pickLocation(
          initialSelection: _selection,
        );

    if (!mounted || selection == null) {
      return;
    }

    setState(() {
      _selection = selection;
    });
  }

  Future<void> _saveAndContinue() async {
    final formIsValid = _formKey.currentState?.validate() ?? false;
    if (!formIsValid) {
      return;
    }
    if (_selection == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please choose a location on the map.')),
      );
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      final authRepository = ref.read(authRepositoryProvider);
      final locationRepository = ref.read(locationRepositoryProvider);
      final user = await authRepository.currentUser();
      if (user == null) {
        throw Exception('No active session found while saving location.');
      }

      final location = LocationDraftFactory.fromSelection(
        id: 'location-${DateTime.now().millisecondsSinceEpoch}',
        userId: user.id,
        name: _nameController.text.trim(),
        selection: _selection!,
        createdAt: DateTime.now().toUtc(),
      );

      final savedLocation = await locationRepository.saveLocation(location);
      await locationRepository.setActiveLocation(savedLocation.id);
      final invalidate = ref.invalidate;
      invalidate(locationsProvider);
      invalidate(activeLocationProvider);
      invalidate(authRouteStateProvider);

      if (mounted) {
        context.go(AppRoutes.crops);
      }
    } on Exception {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not save location. Please try again.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }
}
