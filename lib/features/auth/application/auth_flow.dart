import 'package:damkina_app/core/routing/app_routes.dart';
import 'package:damkina_app/shared/models/app_user.dart';

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
