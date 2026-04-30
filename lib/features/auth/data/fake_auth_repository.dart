import 'dart:async';

import 'package:damkina_app/features/auth/domain/auth_repository.dart';
import 'package:damkina_app/shared/models/app_user.dart';

class FakeAuthRepository implements AuthRepository {
  final StreamController<AuthSessionEvent> _authStateController =
      StreamController<AuthSessionEvent>.broadcast();
  AppUser? _user;

  @override
  Stream<AuthSessionEvent> authStateChanges() => _authStateController.stream;

  @override
  bool get hasActiveSession => _user != null;

  @override
  Future<AppUser?> currentUser() async => _user;

  @override
  Future<AppUser> saveDisplayName(String displayName) async {
    final current = _user ?? await signInWithDevelopmentAccount();
    _user = current.copyWith(customName: displayName.trim());
    _authStateController.add(AuthSessionEvent.changed);
    return _user!;
  }

  @override
  Future<void> signInWithGoogle() async {
    await signInWithDevelopmentAccount();
  }

  @override
  Future<AppUser> signInWithDevelopmentAccount() async {
    _user ??= AppUser(
      id: 'user-dev-001',
      providerId: 'fake-dev',
      email: 'dev@damkina.local',
      displayName: 'Damkina Dev',
      customName: 'Damkina Dev',
      createdAt: DateTime.utc(2026, 4, 21),
    );
    _authStateController.add(AuthSessionEvent.changed);

    return _user!;
  }

  @override
  Future<void> signOut() async {
    _user = null;
    _authStateController.add(AuthSessionEvent.changed);
  }
}
