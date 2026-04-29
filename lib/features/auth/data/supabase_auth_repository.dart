import 'package:damkina_app/core/config/app_config.dart';
import 'package:damkina_app/features/auth/domain/auth_repository.dart';
import 'package:damkina_app/shared/models/app_user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository({
    required SupabaseClient client,
    required AppConfig appConfig,
  }) : _client = client,
       _appConfig = appConfig;

  final SupabaseClient _client;
  final AppConfig _appConfig;

  @override
  Stream<Object?> authStateChanges() {
    return _client.auth.onAuthStateChange;
  }

  @override
  Future<AppUser?> currentUser() async {
    final authUser = _client.auth.currentUser;
    if (authUser == null) {
      return null;
    }

    final profile = await _getProfile(authUser.id);
    final googleDisplayName = _readGoogleDisplayName(authUser);
    final displayName =
        _nonEmpty(profile?.displayName) ??
        _nonEmpty(googleDisplayName) ??
        _nonEmpty(authUser.email) ??
        'Damkina user';
    return AppUser(
      id: authUser.id,
      providerId: authUser.appMetadata['provider'] as String? ?? 'supabase',
      email: authUser.email ?? '',
      displayName: displayName,
      customName: _nonEmpty(profile?.customName),
      avatarUrl:
          _nonEmpty(profile?.avatarUrl) ??
          _nonEmpty(authUser.userMetadata?['avatar_url'] as String?),
    );
  }

  @override
  Future<AppUser> saveDisplayName(String displayName) async {
    final authUser = _client.auth.currentUser;
    if (authUser == null) {
      throw StateError('Cannot save a display name without an active session.');
    }

    final trimmedCustomName = displayName.trim();
    final googleDisplayName = _readGoogleDisplayName(authUser);
    final profileDisplayName =
        _nonEmpty(googleDisplayName) ??
        _nonEmpty(authUser.email) ??
        'Damkina user';

    await _client.from('profiles').upsert({
      'id': authUser.id,
      'display_name': profileDisplayName,
      'custom_name': trimmedCustomName,
      'avatar_url': authUser.userMetadata?['avatar_url'],
    });

    return AppUser(
      id: authUser.id,
      providerId: authUser.appMetadata['provider'] as String? ?? 'supabase',
      email: authUser.email ?? '',
      displayName: profileDisplayName,
      customName: trimmedCustomName,
      avatarUrl: _nonEmpty(authUser.userMetadata?['avatar_url'] as String?),
    );
  }

  @override
  Future<void> signInWithGoogle() {
    return _client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: _appConfig.googleOAuthRedirectUri,
      authScreenLaunchMode: LaunchMode.externalApplication,
    );
  }

  @override
  Future<AppUser> signInWithDevelopmentAccount() {
    throw UnsupportedError(
      'Development account login is not available in SupabaseAuthRepository.',
    );
  }

  @override
  Future<void> signOut() => _client.auth.signOut();

  Future<_ProfileRow?> _getProfile(String userId) async {
    final data = await _client
        .from('profiles')
        .select('display_name, custom_name, avatar_url')
        .eq('id', userId)
        .maybeSingle();

    if (data == null) {
      return null;
    }

    return _ProfileRow(
      displayName: data['display_name'] as String?,
      customName: data['custom_name'] as String?,
      avatarUrl: data['avatar_url'] as String?,
    );
  }

  String? _readGoogleDisplayName(User authUser) {
    return _nonEmpty(authUser.userMetadata?['name'] as String?);
  }

  String? _nonEmpty(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }
}

class _ProfileRow {
  const _ProfileRow({
    required this.displayName,
    required this.customName,
    required this.avatarUrl,
  });

  final String? displayName;
  final String? customName;
  final String? avatarUrl;
}
