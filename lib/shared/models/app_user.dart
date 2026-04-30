import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

@freezed
abstract class AppUser with _$AppUser {
  const factory AppUser({
    required String id,
    required String providerId,
    required String email,
    required String displayName,
    String? customName,
    String? avatarUrl,
    DateTime? createdAt,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);
}
