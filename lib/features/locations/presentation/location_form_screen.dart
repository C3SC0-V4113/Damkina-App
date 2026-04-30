import 'package:damkina_app/core/theme/app_tokens.dart';
import 'package:damkina_app/features/locations/application/location_draft_factory.dart';
import 'package:damkina_app/features/locations/application/location_providers.dart';
import 'package:damkina_app/features/locations/domain/map_picker.dart';
import 'package:damkina_app/shared/models/location.dart';
import 'package:damkina_app/shared/providers/repository_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LocationFormScreen extends ConsumerWidget {
  const LocationFormScreen({
    required this.mode,
    this.locationId,
    super.key,
  });

  final LocationFormMode mode;
  final String? locationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (mode == LocationFormMode.create) {
      return const _LocationFormView(mode: LocationFormMode.create);
    }

    final id = locationId;
    if (id == null) {
      return const _LocationFormError(message: 'Location id is required.');
    }

    final locationAsync = ref.watch(locationByIdProvider(id));
    return locationAsync.when(
      data: (location) {
        if (location == null) {
          return const _LocationFormError(message: 'Location was not found.');
        }
        return _LocationFormView(
          mode: LocationFormMode.edit,
          initialLocation: location,
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (_, _) => const _LocationFormError(
        message: 'Could not load location.',
      ),
    );
  }
}

class _LocationFormView extends ConsumerStatefulWidget {
  const _LocationFormView({
    required this.mode,
    this.initialLocation,
  });

  final LocationFormMode mode;
  final Location? initialLocation;

  @override
  ConsumerState<_LocationFormView> createState() => _LocationFormViewState();
}

class _LocationFormViewState extends ConsumerState<_LocationFormView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  MapSelection? _selection;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.initialLocation?.name ?? '',
    );
    final initialLocation = widget.initialLocation;
    if (initialLocation != null) {
      _selection = MapSelection(
        latitude: initialLocation.latitude,
        longitude: initialLocation.longitude,
        altitude: initialLocation.altitude,
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = switch (widget.mode) {
      LocationFormMode.create => 'Add location',
      LocationFormMode.edit => 'Edit location',
    };

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(labelText: 'Location name'),
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
                  onPressed: _saving ? null : _saveLocation,
                  child: _saving
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          widget.mode == LocationFormMode.create
                              ? 'Create location'
                              : 'Save changes',
                        ),
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

  Future<void> _saveLocation() async {
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
      final existing = widget.initialLocation;

      final location = LocationDraftFactory.fromSelection(
        id: existing?.id ?? 'location-${DateTime.now().millisecondsSinceEpoch}',
        userId: existing?.userId ?? user.id,
        name: _nameController.text.trim(),
        selection: _selection!,
        createdAt: DateTime.now().toUtc(),
        base: existing,
      );

      await locationRepository.saveLocation(location);
      final invalidate = ref.invalidate;
      invalidate(locationsProvider);
      invalidate(activeLocationProvider);
      if (existing != null) {
        invalidate(locationByIdProvider(existing.id));
      }

      if (mounted) {
        context.pop();
      }
    } on Exception {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not save location.')),
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

class _LocationFormError extends StatelessWidget {
  const _LocationFormError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Location')),
      body: Center(child: Text(message)),
    );
  }
}

enum LocationFormMode {
  create,
  edit,
}
