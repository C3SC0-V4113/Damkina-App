import 'package:damkina_app/core/theme/app_tokens.dart';
import 'package:damkina_app/features/auth/application/auth_providers.dart';
import 'package:damkina_app/features/profile/application/profile_providers.dart';
import 'package:damkina_app/shared/providers/repository_providers.dart';
import 'package:damkina_app/shared/widgets/design_title_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isSigningOut = false;

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileViewDataProvider);

    return Scaffold(
      appBar: const DesignTitleAppBar(
        title: 'Perfil',
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: profileAsync.when(
          data: (profile) {
            if (profile == null) {
              return const Center(
                child: Text('No hay una sesión activa en este momento.'),
              );
            }

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.xl,
                    AppSpacing.lg,
                    AppSpacing.xl,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _ProfileHeader(profile: profile),
                      const SizedBox(height: AppSpacing.xl),
                      Text(
                        'Detalles de la cuenta',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: AppColors.forest,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm,
                          ),
                          child: Column(
                            children: [
                              _ProfileDetailRow(
                                icon: Icons.mail_outline_rounded,
                                label: 'Correo',
                                value: profile.email,
                              ),
                              const Divider(height: 1, color: AppColors.line),
                              _ProfileDetailRow(
                                icon: Icons.location_on_outlined,
                                label: 'Ubicación principal',
                                value:
                                    profile.primaryLocationName ??
                                    'No disponible',
                              ),
                              const Divider(height: 1, color: AppColors.line),
                              _ProfileDetailRow(
                                icon: Icons.event_outlined,
                                label: 'Miembro desde',
                                value: _formatMemberSince(profile.createdAt),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      Align(
                        child: TextButton.icon(
                          onPressed: _isSigningOut ? null : _onSignOutPressed,
                          icon: _isSigningOut
                              ? const SizedBox.square(
                                  dimension: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.danger,
                                  ),
                                )
                              : const Icon(Icons.logout_rounded),
                          label: Text(
                            _isSigningOut
                                ? 'Cerrando sesión...'
                                : 'Cerrar sesión',
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.danger,
                            textStyle: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => const Center(
            child: Text('No se pudo cargar la información del perfil.'),
          ),
        ),
      ),
    );
  }

  Future<void> _onSignOutPressed() async {
    final confirmed = await _showSignOutSheet(context);
    if (!confirmed || !mounted) {
      return;
    }

    setState(() {
      _isSigningOut = true;
    });

    try {
      await ref.read(authRepositoryProvider).signOut();
      ref
        ..invalidate(profileViewDataProvider)
        ..invalidate(profileUserProvider)
        ..invalidate(currentUserProvider)
        ..invalidate(authRouteStateProvider);
    } on Exception {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo cerrar la sesión. Intenta nuevamente.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSigningOut = false;
        });
      }
    }
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.profile});

  final ProfileViewData profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 42,
          backgroundColor: AppColors.mist,
          backgroundImage: _avatarImage(profile.avatarUrl),
          child: _avatarImage(profile.avatarUrl) == null
              ? const Icon(
                  Icons.person_rounded,
                  size: 40,
                  color: AppColors.forest,
                )
              : null,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          profile.visibleName,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppColors.ink,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  ImageProvider<Object>? _avatarImage(String? avatarUrl) {
    final trimmedUrl = avatarUrl?.trim();
    if (trimmedUrl == null || trimmedUrl.isEmpty) {
      return null;
    }
    return NetworkImage(trimmedUrl);
  }
}

class _ProfileDetailRow extends StatelessWidget {
  const _ProfileDetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.mist,
              borderRadius: BorderRadius.circular(AppRadii.md),
            ),
            child: Icon(icon, color: AppColors.forest, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: AppColors.mutedInk,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  value,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.ink,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.line,
          ),
        ],
      ),
    );
  }
}

Future<bool> _showSignOutSheet(BuildContext context) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const _SignOutSheet(),
  );

  return result ?? false;
}

class _SignOutSheet extends StatelessWidget {
  const _SignOutSheet();

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
                    Icons.logout_rounded,
                    color: AppColors.danger,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  '¿Cerrar sesión?',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: AppColors.ink,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Tendrás que volver a iniciar sesión para acceder a tus '
                  'ubicaciones y recomendaciones.',
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
                    child: const Text('Cerrar sesión'),
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

String _formatMemberSince(DateTime? createdAt) {
  if (createdAt == null) {
    return 'No disponible';
  }

  const months = <String>[
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre',
  ];

  return '${months[createdAt.month - 1]} ${createdAt.year}';
}
