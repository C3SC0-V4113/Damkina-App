import 'package:damkina_app/features/auth/domain/auth_repository.dart';
import 'package:damkina_app/shared/models/app_user.dart';

class FakeAuthRepository implements AuthRepository {
  AppUser? _user = const AppUser(
    id: 'user-dev-001',
    providerId: 'fake-dev',
    email: 'dev@damkina.local',
    displayName: 'Damkina Dev',
    customName: 'Damkina Dev',
  );

  @override
  Future<AppUser?> currentUser() async => _user;

  @override
  Future<AppUser> saveDisplayName(String displayName) async {
    final current = _user ?? await signInWithDevelopmentAccount();
    _user = current.copyWith(customName: displayName);
    return _user!;
  }

  @override
  Future<AppUser> signInWithDevelopmentAccount() async {
    _user ??= const AppUser(
      id: 'user-dev-001',
      providerId: 'fake-dev',
      email: 'dev@damkina.local',
      displayName: 'Damkina Dev',
      customName: 'Damkina Dev',
    );

    return _user!;
  }

  @override
  Future<void> signOut() async {
    _user = null;
  }
}
