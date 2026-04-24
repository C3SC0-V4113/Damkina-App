import 'package:damkina_app/shared/models/recommendation.dart';

abstract interface class RecommendationRepository {
  Future<List<Recommendation>> listRecommendationsForLocation(
    String locationId,
  );

  Future<Recommendation?> getRecommendation({
    required String cropId,
    required String locationId,
  });
}
