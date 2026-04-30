import 'package:damkina_app/features/auth/application/auth_providers.dart';
import 'package:damkina_app/features/locations/application/location_providers.dart';
import 'package:damkina_app/shared/models/app_user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final FutureProvider<AppUser?> profileUserProvider = currentUserProvider;

@immutable
class ProfileViewData {
  const ProfileViewData({
    required this.visibleName,
    required this.email,
    required this.avatarUrl,
    required this.primaryLocationName,
    required this.createdAt,
  });

  final String visibleName;
  final String email;
  final String? avatarUrl;
  final String? primaryLocationName;
  final DateTime? createdAt;
}

final profileViewDataProvider = Provider<AsyncValue<ProfileViewData?>>((ref) {
  final userAsync = ref.watch(profileUserProvider);
  final activeLocationAsync = ref.watch(activeLocationProvider);

  if (userAsync.isLoading || activeLocationAsync.isLoading) {
    return const AsyncValue.loading();
  }

  if (userAsync.hasError) {
    final error = userAsync.asError!;
    return AsyncValue.error(error.error, error.stackTrace);
  }

  if (activeLocationAsync.hasError) {
    final error = activeLocationAsync.asError!;
    return AsyncValue.error(error.error, error.stackTrace);
  }

  final user = userAsync.value;
  if (user == null) {
    return const AsyncValue.data(null);
  }

  final trimmedCustomName = user.customName?.trim();
  return AsyncValue.data(
    ProfileViewData(
      visibleName: (trimmedCustomName?.isNotEmpty ?? false)
          ? trimmedCustomName!
          : user.displayName,
      email: user.email,
      avatarUrl: user.avatarUrl,
      primaryLocationName: activeLocationAsync.value?.name,
      createdAt: user.createdAt,
    ),
  );
});
