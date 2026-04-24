import 'package:damkina_app/shared/models/crop.dart';

abstract interface class CropRepository {
  Future<List<Crop>> listCrops();

  Future<Crop?> getCropById(String id);
}
