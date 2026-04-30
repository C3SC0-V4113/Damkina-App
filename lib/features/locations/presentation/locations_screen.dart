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
                          case _LocationAction.edit:
                            if (!context.mounted) {
                              return;
                            }
                            context.go('/locations/${location.id}/edit');
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

enum _LocationAction {
  setActive,
  edit,
}
