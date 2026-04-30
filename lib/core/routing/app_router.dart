import 'package:damkina_app/core/routing/app_routes.dart';
import 'package:damkina_app/core/routing/router_keys.dart';
import 'package:damkina_app/features/auth/application/auth_flow.dart';
import 'package:damkina_app/features/auth/application/auth_providers.dart';
import 'package:damkina_app/features/auth/presentation/auth_gate_screen.dart';
import 'package:damkina_app/features/auth/presentation/login_screen.dart';
import 'package:damkina_app/features/crops/presentation/crop_detail_screen.dart';
import 'package:damkina_app/features/crops/presentation/crops_screen.dart';
import 'package:damkina_app/features/locations/presentation/location_form_screen.dart';
import 'package:damkina_app/features/locations/presentation/locations_screen.dart';
import 'package:damkina_app/features/onboarding/presentation/onboarding_location_screen.dart';
import 'package:damkina_app/features/onboarding/presentation/onboarding_name_screen.dart';
import 'package:damkina_app/features/profile/presentation/profile_screen.dart';
import 'package:damkina_app/shared/widgets/damkina_shell.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshListenable = ValueNotifier<int>(0);
  final lifecycleObserver = _RouterLifecycleObserver(
    onResume: () {
      refreshListenable.value++;
    },
  );
  WidgetsBinding.instance.addObserver(lifecycleObserver);
  ref
    ..onDispose(() {
      WidgetsBinding.instance.removeObserver(lifecycleObserver);
      refreshListenable.dispose();
    })
    ..listen<AsyncValue<AuthRouteState>>(
      authRouteStateProvider,
      (previous, next) => refreshListenable.value++,
    );

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.launch,
    refreshListenable: refreshListenable,
    redirect: (context, state) {
      final authState = ref.read(authRouteStateProvider);
      final location = state.matchedLocation;

      final isAtLaunch = location == AppRoutes.launch;
      final isAtLogin = location == AppRoutes.login;
      final isAtOnboardingName = location == AppRoutes.onboardingName;
      final isAtOnboardingLocation = location == AppRoutes.onboardingLocation;

      return authState.when(
        data: (value) {
          if (value == AuthRouteState.loading) {
            return isAtLaunch ? null : AppRoutes.launch;
          }

          if (value == AuthRouteState.unauthenticated) {
            return isAtLogin ? null : AppRoutes.login;
          }

          if (value == AuthRouteState.needsName) {
            return isAtOnboardingName ? null : AppRoutes.onboardingName;
          }

          if (value == AuthRouteState.needsLocation) {
            return isAtOnboardingLocation ? null : AppRoutes.onboardingLocation;
          }

          final isInAuthFlow =
              isAtLaunch ||
              isAtLogin ||
              isAtOnboardingName ||
              isAtOnboardingLocation;
          if (isInAuthFlow) {
            return AppRoutes.crops;
          }

          return null;
        },
        loading: () => isAtLaunch ? null : AppRoutes.launch,
        error: (_, _) => isAtLaunch ? null : AppRoutes.launch,
      );
    },
    routes: [
      GoRoute(
        path: AppRoutes.launch,
        builder: (context, state) => const AuthGateScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingName,
        builder: (context, state) => const OnboardingNameScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingLocation,
        builder: (context, state) => const OnboardingLocationScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return DamkinaShell(
            location: state.uri.path,
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: AppRoutes.crops,
            builder: (context, state) => const CropsScreen(),
            routes: [
              GoRoute(
                path: ':cropId',
                builder: (context, state) {
                  return CropDetailScreen(
                    cropId: state.pathParameters['cropId']!,
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.locations,
            builder: (context, state) => const LocationsScreen(),
            routes: [
              GoRoute(
                path: 'new',
                builder: (context, state) {
                  return const LocationFormScreen(
                    mode: LocationFormMode.create,
                  );
                },
              ),
              GoRoute(
                path: ':locationId/edit',
                builder: (context, state) {
                  return LocationFormScreen(
                    mode: LocationFormMode.edit,
                    locationId: state.pathParameters['locationId'],
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.profile,
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );
});

class _RouterLifecycleObserver extends WidgetsBindingObserver {
  _RouterLifecycleObserver({required this.onResume});

  final VoidCallback onResume;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      onResume();
    }
  }
}
