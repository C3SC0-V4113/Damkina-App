import 'package:damkina_app/core/routing/app_routes.dart';
import 'package:damkina_app/core/theme/app_tokens.dart';
import 'package:damkina_app/features/locations/application/location_providers.dart';
import 'package:damkina_app/shared/providers/repository_providers.dart';
import 'package:damkina_app/shared/widgets/design_title_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LocationsScreen extends ConsumerWidget {
  const LocationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationsAsync = ref.watch(locationsProvider);
    final activeLocationAsync = ref.watch(activeLocationProvider);

    return Scaffold(
      appBar: const DesignTitleAppBar(
        title: 'Ubicaciones',
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go(AppRoutes.locationNew),
        icon: const Icon(Icons.add),
        label: const Text('Agregar ubicacion'),
      ),
      body: SafeArea(
        child: locationsAsync.when(
          data: (locations) {
            if (locations.isEmpty) {
              return const Center(
                child: Text('Aun no hay ubicaciones guardadas.'),
              );
            }

            final activeId = activeLocationAsync.asData?.value?.id;
            return ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemBuilder: (context, index) {
                final location = locations[index];
                final isActive = location.id == activeId;
                final addressAsync = ref.watch(
                  locationAddressProvider((
                    location.latitude,
                    location.longitude,
                  )),
                );
                return Card(
                  child: ListTile(
                    title: Text(location.name),
                    subtitle: Text(_addressLabelFromAsync(addressAsync)),
                    leading: Icon(
                      isActive ? Icons.check_circle : Icons.place_outlined,
                      color: isActive ? AppColors.forest : null,
                    ),
                    trailing: PopupMenuButton<_LocationAction>(
                      onSelected: (action) async {
                        switch (action) {
                          case _LocationAction.setActive:
                            await ref
                                .read(locationRepositoryProvider)
                                .setActiveLocation(location.id);
                            ref.invalidate(activeLocationProvider);
                            return;
                          case _LocationAction.edit:
                            if (!context.mounted) {
                              return;
                            }
                            context.go('/locations/${location.id}/edit');
                            return;
                          case _LocationAction.delete:
                            final confirmed = await _showDeleteLocationSheet(
                              context,
                            );
                            if (!confirmed || !context.mounted) {
                              return;
                            }

                            try {
                              await ref
                                  .read(locationRepositoryProvider)
                                  .deleteLocation(location.id);
                              ref
                                ..invalidate(locationsProvider)
                                ..invalidate(activeLocationProvider)
                                ..invalidate(locationByIdProvider(location.id));
                            } on Exception {
                              if (!context.mounted) {
                                return;
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'No se pudo eliminar la ubicacion.',
                                  ),
                                ),
                              );
                            }
                            return;
                        }
                      },
                      itemBuilder: (context) => [
                        if (!isActive)
                          const PopupMenuItem(
                            value: _LocationAction.setActive,
                            child: Text('Definir activa'),
                          ),
                        const PopupMenuItem(
                          value: _LocationAction.edit,
                          child: Text('Editar'),
                        ),
                        const PopupMenuItem(
                          value: _LocationAction.delete,
                          child: Text('Eliminar'),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
              itemCount: locations.length,
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => const Center(
            child: Text('No se pudieron cargar las ubicaciones.'),
          ),
        ),
      ),
    );
  }
}

String _addressLabelFromAsync(AsyncValue<String?> asyncValue) {
  return switch (asyncValue) {
    AsyncData(:final value) => value ?? 'Direccion no disponible por ahora.',
    AsyncError() => 'Direccion no disponible por ahora.',
    _ => 'Resolviendo direccion...',
  };
}

Future<bool> _showDeleteLocationSheet(BuildContext context) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const _DeleteLocationSheet(),
  );

  return result ?? false;
}

class _DeleteLocationSheet extends StatelessWidget {
  const _DeleteLocationSheet();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.md,
        ),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: AppColors.cream,
            borderRadius: BorderRadius.all(Radius.circular(AppRadii.lg)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.line,
                    borderRadius: BorderRadius.circular(AppRadii.sm),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.danger.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.warning_rounded,
                    color: AppColors.danger,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  '¿Eliminar ubicación?',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: AppColors.ink,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Esta acción no se puede deshacer. Perderás las '
                  'recomendaciones personalizadas para este terreno.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.mutedInk,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.danger,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.md,
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Eliminar'),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.line,
                      foregroundColor: AppColors.ink,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.md,
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancelar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum _LocationAction {
  setActive,
  edit,
  delete,
}
