import 'package:damkina_app/features/locations/domain/map_picker.dart';

class FakeMapPicker implements MapPicker {
  @override
  Future<MapSelection?> pickLocation({
    MapSelection? initialSelection,
  }) async {
    return initialSelection ??
        const MapSelection(
          latitude: 13.8414,
          longitude: -89.7456,
          altitude: 1040,
        );
  }
}
