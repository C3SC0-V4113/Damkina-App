import 'package:damkina_app/features/locations/domain/map_picker.dart';
import 'package:damkina_app/shared/models/location.dart';

class LocationDraftFactory {
  const LocationDraftFactory._();

  static Location fromSelection({
    required String id,
    required String userId,
    required String name,
    required MapSelection selection,
    required DateTime createdAt,
    Location? base,
  }) {
    return Location(
      id: id,
      userId: userId,
      name: name,
      latitude: selection.latitude,
      longitude: selection.longitude,
      altitude: selection.altitude ?? base?.altitude ?? 0,
      koppenClassification: base?.koppenClassification ?? 'pending',
      climateSummary:
          base?.climateSummary ?? 'Environmental profile pending enrichment.',
      seasonalitySummary:
          base?.seasonalitySummary ?? 'Seasonality data pending enrichment.',
      currentSeason: base?.currentSeason ?? 'Pending',
      createdAt: base?.createdAt ?? createdAt,
    );
  }
}
