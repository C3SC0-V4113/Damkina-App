// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crop.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Crop _$CropFromJson(Map<String, dynamic> json) => _Crop(
  id: json['id'] as String,
  name: json['name'] as String,
  slug: json['slug'] as String,
  shortDescription: json['shortDescription'] as String,
  minHarvestDays: (json['minHarvestDays'] as num).toInt(),
  maxHarvestDays: (json['maxHarvestDays'] as num).toInt(),
  difficulty: json['difficulty'] as String,
  soilType: json['soilType'] as String,
  soilPhMin: (json['soilPhMin'] as num).toDouble(),
  soilPhMax: (json['soilPhMax'] as num).toDouble(),
  sunHoursMin: (json['sunHoursMin'] as num).toInt(),
  sunHoursMax: (json['sunHoursMax'] as num).toInt(),
  sunlightIntensity: json['sunlightIntensity'] as String,
  waterRequirement: json['waterRequirement'] as String,
  idealTempMin: (json['idealTempMin'] as num).toDouble(),
  idealTempMax: (json['idealTempMax'] as num).toDouble(),
  altitudeMin: (json['altitudeMin'] as num).toInt(),
  altitudeMax: (json['altitudeMax'] as num).toInt(),
  preferredKoppenTypes: (json['preferredKoppenTypes'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  images: (json['images'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$CropToJson(_Crop instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'slug': instance.slug,
  'shortDescription': instance.shortDescription,
  'minHarvestDays': instance.minHarvestDays,
  'maxHarvestDays': instance.maxHarvestDays,
  'difficulty': instance.difficulty,
  'soilType': instance.soilType,
  'soilPhMin': instance.soilPhMin,
  'soilPhMax': instance.soilPhMax,
  'sunHoursMin': instance.sunHoursMin,
  'sunHoursMax': instance.sunHoursMax,
  'sunlightIntensity': instance.sunlightIntensity,
  'waterRequirement': instance.waterRequirement,
  'idealTempMin': instance.idealTempMin,
  'idealTempMax': instance.idealTempMax,
  'altitudeMin': instance.altitudeMin,
  'altitudeMax': instance.altitudeMax,
  'preferredKoppenTypes': instance.preferredKoppenTypes,
  'images': instance.images,
};
