import 'package:damkina_app/core/routing/app_routes.dart';
import 'package:damkina_app/core/theme/app_tokens.dart';
import 'package:damkina_app/features/auth/application/auth_providers.dart';
import 'package:damkina_app/features/locations/application/location_draft_factory.dart';
import 'package:damkina_app/features/locations/application/location_providers.dart';
import 'package:damkina_app/features/locations/domain/map_picker.dart';
import 'package:damkina_app/features/onboarding/presentation/onboarding_step_header.dart';
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
  final _nameController = TextEditingController(text: 'Mi primer huerto');
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
      appBar: const OnboardingProgressAppBar(
        title: 'Establecer ubicacion',
        subtitle: 'Paso 2 de 2: Tu primer huerto',
        progress: 1,
      ),
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
                          'Elige la ubicacion de tu primer huerto.',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Selecciona un punto en el mapa y guardalo '
                          'como tu ubicacion activa.',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: AppColors.mutedInk,
                              ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        TextFormField(
                          controller: _nameController,
                          textInputAction: TextInputAction.done,
                          decoration: const InputDecoration(
                            labelText: 'Nombre de ubicacion',
                            hintText:
                                'Casa, Parcela Norte, Terreno de Juayua...',
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
                          onPressed: _saving ? null : _saveAndContinue,
                          child: _saving
                              ? const SizedBox.square(
                                  dimension: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Guardar y ver cultivos'),
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

  Future<void> _saveAndContinue() async {
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
          content: Text(
            'No se pudo guardar la ubicacion. Intenta nuevamente.',
          ),
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
