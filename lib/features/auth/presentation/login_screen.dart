import 'package:damkina_app/core/theme/app_tokens.dart';
import 'package:damkina_app/features/auth/application/auth_providers.dart';
import 'package:damkina_app/shared/providers/repository_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(_lifecycleObserver);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(_lifecycleObserver);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadii.lg),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.xxl,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/damkina_icon.svg',
                            width: 22,
                            height: 22,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            'Damkina',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: AppColors.forest,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        'Bienvenido',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Comienza tu viaje hacia una vida más conectada '
                        'con la naturaleza.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.mutedInk,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      OutlinedButton.icon(
                        onPressed: _isSubmitting ? null : _signInWithGoogle,
                        icon: const Icon(Icons.g_mobiledata_rounded),
                        label: Text(
                          _isSubmitting
                              ? 'Conectando...'
                              : 'Continue with Google',
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      Text(
                        'AL CONTINUAR, ACEPTAS NUESTROS\n'
                        'TERMINOS DE SERVICIO Y POLITICA\n'
                        'DE PRIVACIDAD.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.mutedInk,
                          letterSpacing: 0.3,
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
    );
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      await ref.read(authRepositoryProvider).signInWithGoogle();
    } on Exception catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No fue posible iniciar sesión: $error')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  late final WidgetsBindingObserver _lifecycleObserver =
      _LoginLifecycleObserver(
        onResumed: () {
          if (!mounted) {
            return;
          }
          ref
            ..invalidate(currentUserProvider)
            ..invalidate(authRouteStateProvider);
        },
      );
}

class _LoginLifecycleObserver extends WidgetsBindingObserver {
  _LoginLifecycleObserver({required this.onResumed});

  final VoidCallback onResumed;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      onResumed();
    }
  }
}
