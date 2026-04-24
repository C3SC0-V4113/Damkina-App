import 'package:damkina_app/shared/models/app_user.dart';
import 'package:damkina_app/shared/providers/repository_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentUserProvider = FutureProvider<AppUser?>((ref) {
  return ref.watch(authRepositoryProvider).currentUser();
});
