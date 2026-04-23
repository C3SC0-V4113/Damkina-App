import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/models/app_user.dart';
import '../../../shared/providers/repository_providers.dart';

final currentUserProvider = FutureProvider<AppUser?>((ref) {
  return ref.watch(authRepositoryProvider).currentUser();
});
