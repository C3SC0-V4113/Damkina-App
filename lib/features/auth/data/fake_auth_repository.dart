import '../../../shared/models/app_user.dart';
import '../domain/auth_repository.dart';

class FakeAuthRepository implements AuthRepository {
  AppUser? _user = const AppUser(
    id: 'user-dev-001',
    providerId: 'fake-dev',
    email: 'dev@damkina.local',
    displayName: 'Damkina Dev',
    customName: 'Damkina Dev',
    avatarUrl: null,
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
      avatarUrl: null,
    );

    return _user!;
  }

  @override
  Future<void> signOut() async {
    _user = null;
  }
}
