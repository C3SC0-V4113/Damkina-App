import '../../../shared/models/recommendation.dart';
import '../domain/recommendation_repository.dart';

class FakeRecommendationRepository implements RecommendationRepository {
  final List<Recommendation> _recommendations = const [
    Recommendation(
      id: 'recommendation-tomato-juayua',
      cropId: 'crop-tomato',
      locationId: 'location-juayua',
      score: 0.86,
      level: 'Recommended',
      summary: 'Good fit for altitude and warm seasonal conditions.',
    ),
    Recommendation(
      id: 'recommendation-bean-juayua',
      cropId: 'crop-bean',
      locationId: 'location-juayua',
      score: 0.91,
      level: 'Highly recommended',
      summary: 'Strong fit for small plots and current season.',
    ),
  ];

  @override
  Future<Recommendation?> getRecommendation({
    required String cropId,
    required String locationId,
  }) async {
    for (final recommendation in _recommendations) {
      if (recommendation.cropId == cropId &&
          recommendation.locationId == locationId) {
        return recommendation;
      }
    }

    return null;
  }

  @override
  Future<List<Recommendation>> listRecommendationsForLocation(
    String locationId,
  ) async {
    final matches = _recommendations
        .where((recommendation) => recommendation.locationId == locationId)
        .toList()
      ..sort((left, right) => right.score.compareTo(left.score));

    return matches;
  }
}
