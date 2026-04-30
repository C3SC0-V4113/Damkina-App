import 'dart:async';
import 'dart:io';

import 'package:damkina_app/features/auth/application/auth_flow.dart';
import 'package:damkina_app/shared/models/app_user.dart';
import 'package:damkina_app/shared/providers/repository_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authStateChangesProvider = StreamProvider<int>((ref) {
  var revision = 0;
  return ref
      .watch(authRepositoryProvider)
      .authStateChanges()
      .map((_) => ++revision);
});

final currentUserProvider = FutureProvider<AppUser?>((ref) {
  ref.watch(authStateChangesProvider);
  return ref.watch(authRepositoryProvider).currentUser();
});

final authRouteStateProvider = FutureProvider<AuthRouteState>((ref) async {
  ref.watch(authStateChangesProvider);
  final authRepository = ref.watch(authRepositoryProvider);
  final locationRepository = ref.watch(locationRepositoryProvider);

  void retryShortly() {
    Future<void>.delayed(const Duration(milliseconds: 800), () {
      ref.invalidateSelf();
    });
  }

  try {
    final user = await authRepository.currentUser();
    if (user == null) {
      if (authRepository.hasActiveSession) {
        retryShortly();
        return AuthRouteState.loading;
      }
      return AuthRouteState.unauthenticated;
    }

    final customName = user.customName?.trim() ?? '';
    if (customName.isEmpty) {
      return AuthRouteState.needsName;
    }

    final hasLocation = await locationRepository.hasAnyLocationForUser(user.id);
    if (!hasLocation) {
      return AuthRouteState.needsLocation;
    }

    return AuthRouteState.authenticated;
  } on Exception catch (error) {
    if (!authRepository.hasActiveSession) {
      return AuthRouteState.unauthenticated;
    }

    if (_isTransientAuthRoutingError(error)) {
      retryShortly();
      return AuthRouteState.loading;
    }

    // Non-transient errors (for example RLS/policy/schema issues) should not
    // keep the app in an infinite loading loop.
    AppUser? user;
    try {
      user = await authRepository.currentUser();
    } on Exception {
      // If profile read itself is forbidden/misconfigured, keep app navigable.
      return AuthRouteState.needsName;
    }

    if (user == null) {
      return AuthRouteState.needsName;
    }
    final customName = user.customName?.trim() ?? '';
    if (customName.isEmpty) {
      return AuthRouteState.needsName;
    }
    return AuthRouteState.needsLocation;
  }
});

bool _isTransientAuthRoutingError(Object error) {
  if (error is TimeoutException || error is SocketException) {
    return true;
  }

  if (error is PostgrestException) {
    final code = (error.code ?? '').toUpperCase();
    return code.startsWith('08') ||
        code.startsWith('53') ||
        code.startsWith('57') ||
        code == 'PGRST000' ||
        code == 'PGRST001' ||
        code == 'PGRST002' ||
        code == 'PGRST003' ||
        code == 'PGRST301';
  }

  if (error is AuthException) {
    return error.statusCode == '429' || error.statusCode == '503';
  }

  return false;
}
