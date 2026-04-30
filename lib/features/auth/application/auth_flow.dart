import 'package:damkina_app/core/routing/app_routes.dart';
import 'package:damkina_app/shared/models/app_user.dart';

enum AuthRouteState {
  loading,
  unauthenticated,
  needsName,
  needsLocation,
  authenticated,
}

String resolvePostAuthRoute(AppUser? user) {
  if (user == null) {
    return AppRoutes.login;
  }

  final customName = user.customName?.trim() ?? '';
  if (customName.isEmpty) {
    return AppRoutes.onboardingName;
  }

  return AppRoutes.crops;
}

String routeForAuthState(AuthRouteState state) {
  return switch (state) {
    AuthRouteState.loading => AppRoutes.launch,
    AuthRouteState.unauthenticated => AppRoutes.login,
    AuthRouteState.needsName => AppRoutes.onboardingName,
    AuthRouteState.needsLocation => AppRoutes.onboardingLocation,
    AuthRouteState.authenticated => AppRoutes.crops,
  };
}
