import '../models/circle_models.dart';

abstract class CircleRepository {
  Stream<List<CircleSummary>> watchCircles();

  Stream<List<CirclePost>> watchPosts(String circleId);

  Future<void> createPost({
    required String circleId,
    required String author,
    required String content,
  });
}

class CircleRepositoryException implements Exception {
  const CircleRepositoryException(this.message);

  final String message;

  @override
  String toString() => message;
}
