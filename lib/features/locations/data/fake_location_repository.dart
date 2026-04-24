import 'package:damkina_app/features/locations/domain/location_repository.dart';
import 'package:damkina_app/shared/models/location.dart';

class FakeLocationRepository implements LocationRepository {
  final List<Location> _locations = [
    Location(
      id: 'location-juayua',
      userId: 'user-dev-001',
      name: 'Terreno de Juayua',
      latitude: 13.8414,
      longitude: -89.7456,
      altitude: 1040,
      koppenClassification: 'Aw',
      climateSummary: 'Clima tropical con temporada seca marcada.',
      seasonalitySummary: 'Lluvias entre mayo y octubre.',
      currentSeason: 'Temporada seca',
      createdAt: DateTime.utc(2026, 4, 21),
    ),
    Location(
      id: 'location-casa',
      userId: 'user-dev-001',
      name: 'Casa',
      latitude: 13.6929,
      longitude: -89.2182,
      altitude: 658,
      koppenClassification: 'Aw',
      climateSummary: 'Zona calida con lluvias estacionales.',
      seasonalitySummary: 'Transicion hacia temporada lluviosa.',
      currentSeason: 'Temporada seca',
      createdAt: DateTime.utc(2026, 4, 21),
    ),
  ];

  String _activeLocationId = 'location-juayua';

  @override
  Future<void> deleteLocation(String id) async {
    _locations.removeWhere((location) => location.id == id);
    if (_activeLocationId == id && _locations.isNotEmpty) {
      _activeLocationId = _locations.first.id;
    }
  }

  @override
  Future<Location?> getActiveLocation() async {
    return getLocationById(_activeLocationId);
  }

  @override
  Future<Location?> getLocationById(String id) async {
    for (final location in _locations) {
      if (location.id == id) {
        return location;
      }
    }

    return null;
  }

  @override
  Future<List<Location>> listLocations() async => List.unmodifiable(_locations);

  @override
  Future<Location> saveLocation(Location location) async {
    final index = _locations.indexWhere((item) => item.id == location.id);
    if (index == -1) {
      _locations.add(location);
    } else {
      _locations[index] = location;
    }

    return location;
  }

  @override
  Future<void> setActiveLocation(String id) async {
    final exists = _locations.any((location) => location.id == id);
    if (exists) {
      _activeLocationId = id;
    }
  }
}
