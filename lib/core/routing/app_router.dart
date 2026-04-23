import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/login_screen.dart';
import '../../features/crops/presentation/crop_detail_screen.dart';
import '../../features/crops/presentation/crops_screen.dart';
import '../../features/locations/presentation/location_form_screen.dart';
import '../../features/locations/presentation/locations_screen.dart';
import '../../features/onboarding/presentation/onboarding_location_screen.dart';
import '../../features/onboarding/presentation/onboarding_name_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../shared/widgets/damkina_shell.dart';
import 'app_routes.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.login,
    routes: [
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
                    locationId: state.pathParameters['locationId']!,
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
