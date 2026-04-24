import 'package:damkina_app/features/auth/application/auth_providers.dart';
import 'package:damkina_app/shared/models/app_user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final FutureProvider<AppUser?> profileUserProvider = currentUserProvider;
