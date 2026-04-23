import 'package:freezed_annotation/freezed_annotation.dart';

part 'crop.freezed.dart';
part 'crop.g.dart';

@freezed
abstract class Crop with _$Crop {
  const factory Crop({
    required String id,
    required String name,
    required String slug,
    required String shortDescription,
    required int minHarvestDays,
    required int maxHarvestDays,
    required String difficulty,
    required String soilType,
    required double soilPhMin,
    required double soilPhMax,
    required int sunHoursMin,
    required int sunHoursMax,
    required String sunlightIntensity,
    required String waterRequirement,
    required double idealTempMin,
    required double idealTempMax,
    required int altitudeMin,
    required int altitudeMax,
    required List<String> preferredKoppenTypes,
    required List<String> images,
  }) = _Crop;

  factory Crop.fromJson(Map<String, dynamic> json) => _$CropFromJson(json);
}
