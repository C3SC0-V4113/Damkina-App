// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Location _$LocationFromJson(Map<String, dynamic> json) => _Location(
  id: json['id'] as String,
  userId: json['userId'] as String,
  name: json['name'] as String,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  altitude: (json['altitude'] as num).toDouble(),
  koppenClassification: json['koppenClassification'] as String,
  climateSummary: json['climateSummary'] as String,
  seasonalitySummary: json['seasonalitySummary'] as String,
  currentSeason: json['currentSeason'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$LocationToJson(_Location instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'name': instance.name,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'altitude': instance.altitude,
  'koppenClassification': instance.koppenClassification,
  'climateSummary': instance.climateSummary,
  'seasonalitySummary': instance.seasonalitySummary,
  'currentSeason': instance.currentSeason,
  'createdAt': instance.createdAt.toIso8601String(),
};
