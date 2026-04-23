// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppUser _$AppUserFromJson(Map<String, dynamic> json) => _AppUser(
  id: json['id'] as String,
  providerId: json['providerId'] as String,
  email: json['email'] as String,
  displayName: json['displayName'] as String,
  customName: json['customName'] as String?,
  avatarUrl: json['avatarUrl'] as String?,
);

Map<String, dynamic> _$AppUserToJson(_AppUser instance) => <String, dynamic>{
  'id': instance.id,
  'providerId': instance.providerId,
  'email': instance.email,
  'displayName': instance.displayName,
  'customName': instance.customName,
  'avatarUrl': instance.avatarUrl,
};
