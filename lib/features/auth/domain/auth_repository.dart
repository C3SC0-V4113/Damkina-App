import 'package:damkina_app/shared/models/app_user.dart';

abstract interface class AuthRepository {
  Future<AppUser?> currentUser();

  Future<AppUser> signInWithDevelopmentAccount();

  Future<AppUser> saveDisplayName(String displayName);

  Future<void> signOut();
}
