import 'dart:async';

import 'package:damkina_app/features/auth/domain/auth_repository.dart';
import 'package:damkina_app/shared/models/app_user.dart';

class FakeAuthRepository implements AuthRepository {
  final StreamController<Object?> _authStateController =
      StreamController<Object?>.broadcast();
  AppUser? _user;

  @override
  Stream<Object?> authStateChanges() => _authStateController.stream;

  @override
  Future<AppUser?> currentUser() async => _user;

  @override
  Future<AppUser> saveDisplayName(String displayName) async {
    final current = _user ?? await signInWithDevelopmentAccount();
    _user = current.copyWith(customName: displayName.trim());
    _authStateController.add(null);
    return _user!;
  }

  @override
  Future<void> signInWithGoogle() async {
    await signInWithDevelopmentAccount();
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
    _authStateController.add(null);

    return _user!;
  }

  @override
  Future<void> signOut() async {
    _user = null;
    _authStateController.add(null);
  }
}
