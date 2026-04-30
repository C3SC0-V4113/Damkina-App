import 'package:damkina_app/shared/models/app_user.dart';

enum AuthSessionEvent { changed }

abstract interface class AuthRepository {
  Future<AppUser?> currentUser();

  bool get hasActiveSession;

  Future<void> signInWithGoogle();

  Future<AppUser> signInWithDevelopmentAccount();

  Future<AppUser> saveDisplayName(String displayName);

  Stream<AuthSessionEvent> authStateChanges();

  Future<void> signOut();
}
