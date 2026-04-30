import 'package:damkina_app/core/theme/app_tokens.dart';
import 'package:damkina_app/features/locations/application/location_draft_factory.dart';
import 'package:damkina_app/features/locations/application/location_providers.dart';
import 'package:damkina_app/features/locations/domain/map_picker.dart';
import 'package:damkina_app/shared/models/location.dart';
import 'package:damkina_app/shared/providers/repository_providers.dart';
import 'package:damkina_app/shared/widgets/design_title_app_bar.dart';
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
      return const _LocationFormError(
        message: 'Se requiere el identificador de la ubicacion.',
      );
    }

    final locationAsync = ref.watch(locationByIdProvider(id));
    return locationAsync.when(
      data: (location) {
        if (location == null) {
          return const _LocationFormError(
            message: 'No se encontro la ubicacion.',
          );
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
        message: 'No se pudo cargar la ubicacion.',
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
      LocationFormMode.create => 'Agregar ubicacion',
      LocationFormMode.edit => 'Editar ubicacion',
    };
    final selection = _selection;
    final selectionAddressAsync = selection == null
        ? null
        : ref.watch(
            locationAddressProvider((selection.latitude, selection.longitude)),
          );
    final selectionSummary = switch (selectionAddressAsync) {
      null => 'Aun no has seleccionado una ubicacion.',
      AsyncData(:final value) => value ?? 'Direccion no disponible por ahora.',
      AsyncError() => 'Direccion no disponible por ahora.',
      _ => 'Resolviendo direccion...',
    };

    return Scaffold(
      appBar: DesignTitleAppBar(title: title),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadii.lg),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.lg,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          widget.mode == LocationFormMode.create
                              ? 'Guarda una nueva ubicacion para tus cultivos.'
                              : 'Actualiza la ubicacion seleccionada.',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.mutedInk),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        TextFormField(
                          controller: _nameController,
                          textInputAction: TextInputAction.done,
                          decoration: const InputDecoration(
                            labelText: 'Nombre de ubicacion',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'El nombre de la ubicacion '
                                  'es obligatorio.';
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
                                ? 'Seleccionar en mapa'
                                : 'Actualizar seleccion en mapa',
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(selectionSummary),
                        const SizedBox(height: AppSpacing.xl),
                        FilledButton(
                          onPressed: _saving ? null : _saveLocation,
                          child: _saving
                              ? const SizedBox.square(
                                  dimension: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  widget.mode == LocationFormMode.create
                                      ? 'Crear ubicacion'
                                      : 'Guardar cambios',
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
        const SnackBar(
          content: Text('Elige una ubicacion en el mapa para continuar.'),
        ),
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
        const SnackBar(
          content: Text('No se pudo guardar la ubicacion.'),
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

class _LocationFormError extends StatelessWidget {
  const _LocationFormError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DesignTitleAppBar(
        title: 'Ubicacion',
      ),
      body: Center(child: Text(message)),
    );
  }
}

enum LocationFormMode {
  create,
  edit,
}
