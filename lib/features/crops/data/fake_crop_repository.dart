import '../../../shared/models/crop.dart';
import '../domain/crop_repository.dart';

class FakeCropRepository implements CropRepository {
  final List<Crop> _crops = const [
    Crop(
      id: 'crop-tomato',
      name: 'Tomato',
      slug: 'tomato',
      shortDescription: 'Warm-season crop with manageable soil needs.',
      minHarvestDays: 70,
      maxHarvestDays: 110,
      difficulty: 'Medium',
      soilType: 'Well-drained loam',
      soilPhMin: 6.0,
      soilPhMax: 6.8,
      sunHoursMin: 6,
      sunHoursMax: 8,
      sunlightIntensity: 'High',
      waterRequirement: 'Medium',
      idealTempMin: 18,
      idealTempMax: 29,
      altitudeMin: 0,
      altitudeMax: 1800,
      preferredKoppenTypes: ['Aw', 'Cwb'],
      images: [],
    ),
    Crop(
      id: 'crop-bean',
      name: 'Bean',
      slug: 'bean',
      shortDescription: 'Adaptable staple crop for small plots.',
      minHarvestDays: 55,
      maxHarvestDays: 90,
      difficulty: 'Low',
      soilType: 'Loose fertile soil',
      soilPhMin: 6.0,
      soilPhMax: 7.5,
      sunHoursMin: 5,
      sunHoursMax: 8,
      sunlightIntensity: 'Medium',
      waterRequirement: 'Medium',
      idealTempMin: 16,
      idealTempMax: 28,
      altitudeMin: 300,
      altitudeMax: 1800,
      preferredKoppenTypes: ['Aw', 'Cwa', 'Cwb'],
      images: [],
    ),
  ];

  @override
  Future<Crop?> getCropById(String id) async {
    for (final crop in _crops) {
      if (crop.id == id) {
        return crop;
      }
    }

    return null;
  }

  @override
  Future<List<Crop>> listCrops() async => _crops;
}
