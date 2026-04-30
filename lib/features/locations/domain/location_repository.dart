import 'package:damkina_app/shared/models/location.dart';

abstract interface class LocationRepository {
  Future<List<Location>> listLocations();

  Future<bool> hasAnyLocationForUser(String userId);

  Future<Location?> getLocationById(String id);

  Future<Location?> getActiveLocation();

  Future<Location> saveLocation(Location location);

  Future<void> setActiveLocation(String id);

  Future<void> deleteLocation(String id);
}
