import 'package:damkina_app/shared/models/app_user.dart';

abstract interface class AuthRepository {
  Future<AppUser?> currentUser();

  Future<void> signInWithGoogle();

  Future<AppUser> signInWithDevelopmentAccount();

  Future<AppUser> saveDisplayName(String displayName);

  Stream<Object?> authStateChanges();

  Future<void> signOut();
}
