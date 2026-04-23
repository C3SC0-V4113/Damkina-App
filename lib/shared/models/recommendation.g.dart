// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Recommendation _$RecommendationFromJson(Map<String, dynamic> json) =>
    _Recommendation(
      id: json['id'] as String,
      cropId: json['cropId'] as String,
      locationId: json['locationId'] as String,
      score: (json['score'] as num).toDouble(),
      level: json['level'] as String,
      summary: json['summary'] as String,
    );

Map<String, dynamic> _$RecommendationToJson(_Recommendation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cropId': instance.cropId,
      'locationId': instance.locationId,
      'score': instance.score,
      'level': instance.level,
      'summary': instance.summary,
    };
