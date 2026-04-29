import 'package:damkina_app/core/routing/app_routes.dart';
import 'package:damkina_app/features/auth/application/auth_flow.dart';
import 'package:damkina_app/shared/models/app_user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('resolvePostAuthRoute returns login when user is null', () {
    expect(resolvePostAuthRoute(null), AppRoutes.login);
  });

  test('resolvePostAuthRoute returns onboarding when customName is empty', () {
    const user = AppUser(
      id: 'u1',
      providerId: 'google',
      email: 'user@damkina.test',
      displayName: 'Damkina User',
      customName: '',
    );

    expect(resolvePostAuthRoute(user), AppRoutes.onboardingName);
  });

  test('resolvePostAuthRoute returns crops when customName has value', () {
    const user = AppUser(
      id: 'u1',
      providerId: 'google',
      email: 'user@damkina.test',
      displayName: 'Damkina User',
      customName: 'Fran',
    );

    expect(resolvePostAuthRoute(user), AppRoutes.crops);
  });
}
