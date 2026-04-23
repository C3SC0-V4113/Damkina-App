import 'package:freezed_annotation/freezed_annotation.dart';

part 'location.freezed.dart';
part 'location.g.dart';

@freezed
abstract class Location with _$Location {
  const factory Location({
    required String id,
    required String userId,
    required String name,
    required double latitude,
    required double longitude,
    required double altitude,
    required String koppenClassification,
    required String climateSummary,
    required String seasonalitySummary,
    required String currentSeason,
    required DateTime createdAt,
  }) = _Location;

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);
}
