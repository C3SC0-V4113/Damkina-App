import 'package:damkina_app/features/auth/application/auth_providers.dart';
import 'package:damkina_app/features/locations/application/location_providers.dart';
import 'package:damkina_app/features/profile/application/profile_providers.dart';
import 'package:damkina_app/shared/providers/session_revision_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sessionResetCoordinatorProvider = Provider<SessionResetCoordinator>(
  SessionResetCoordinator.new,
);

class SessionResetCoordinator {
  SessionResetCoordinator(this._ref);

  final Ref _ref;

  void resetUserScopedState() {
    _ref.read(userSessionRevisionProvider.notifier).bump();
    _ref
      ..invalidate(locationsProvider)
      ..invalidate(activeLocationProvider)
      ..invalidate(locationByIdProvider)
      ..invalidate(profileUserProvider)
      ..invalidate(profileViewDataProvider)
      ..invalidate(currentUserProvider)
      ..invalidate(authRouteStateProvider);
  }
}
