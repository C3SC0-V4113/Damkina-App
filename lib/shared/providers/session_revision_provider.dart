import 'package:flutter_riverpod/flutter_riverpod.dart';

final userSessionRevisionProvider =
    NotifierProvider<UserSessionRevisionNotifier, int>(
      UserSessionRevisionNotifier.new,
    );

class UserSessionRevisionNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void bump() {
    state += 1;
  }
}
