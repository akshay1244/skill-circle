import 'dart:async';

import '../models/circle_models.dart';
import 'circle_repository.dart';

class LocalCircleRepository implements CircleRepository {
  LocalCircleRepository.seeded()
    : _circles = {
        'design-circle': CircleSummary(
          id: 'design-circle',
          name: 'Design Circle',
          description: 'Share UI inspiration, feedback, and quick critiques.',
          memberCount: 128,
          postCount: 2,
          accentColorValue: 0xFFECE8FF,
        ),
        'product-builders': CircleSummary(
          id: 'product-builders',
          name: 'Product Builders',
          description:
              'Talk roadmap ideas, validation, and product experiments.',
          memberCount: 214,
          postCount: 2,
          accentColorValue: 0xFFE4F7F0,
        ),
        'flutter-friends': CircleSummary(
          id: 'flutter-friends',
          name: 'Flutter Friends',
          description: 'Exchange widgets, patterns, and performance tips.',
          memberCount: 96,
          postCount: 2,
          accentColorValue: 0xFFFFF1DD,
        ),
      },
      _postsByCircle = {
        'design-circle': [
          CirclePost(
            id: 'design-post-1',
            author: 'Mia',
            content:
                'Just uploaded a new onboarding flow. Would love feedback on the hierarchy.',
            createdAt: DateTime.now().subtract(const Duration(minutes: 12)),
          ),
          CirclePost(
            id: 'design-post-2',
            author: 'Jordan',
            content:
                'Reminder: today\'s mini-review is focused on accessibility wins.',
            createdAt: DateTime.now().subtract(const Duration(hours: 1)),
          ),
        ],
        'product-builders': [
          CirclePost(
            id: 'product-post-1',
            author: 'Alex',
            content:
                'What\'s your favorite way to test demand before writing production code?',
            createdAt: DateTime.now().subtract(const Duration(minutes: 24)),
          ),
          CirclePost(
            id: 'product-post-2',
            author: 'Sam',
            content:
                'We cut our launch checklist from 18 steps to 7 and shipped faster.',
            createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          ),
        ],
        'flutter-friends': [
          CirclePost(
            id: 'flutter-post-1',
            author: 'Taylor',
            content:
                'Hot tip: use SliverList when you want more flexible scrolling layouts.',
            createdAt: DateTime.now().subtract(const Duration(minutes: 9)),
          ),
          CirclePost(
            id: 'flutter-post-2',
            author: 'Chris',
            content:
                'Sharing a neat animation pattern for tappable cards later today.',
            createdAt: DateTime.now().subtract(const Duration(hours: 3)),
          ),
        ],
      };

  final Map<String, CircleSummary> _circles;
  final Map<String, List<CirclePost>> _postsByCircle;
  final StreamController<List<CircleSummary>> _circlesController =
      StreamController<List<CircleSummary>>.broadcast();
  final Map<String, StreamController<List<CirclePost>>> _postsControllers = {};

  @override
  Stream<List<CircleSummary>> watchCircles() async* {
    yield _currentCircles();
    yield* _circlesController.stream;
  }

  @override
  Stream<List<CirclePost>> watchPosts(String circleId) async* {
    yield _currentPosts(circleId);
    yield* _postsControllers
        .putIfAbsent(
          circleId,
          () => StreamController<List<CirclePost>>.broadcast(),
        )
        .stream;
  }

  @override
  Future<void> createPost({
    required String circleId,
    required String author,
    required String content,
  }) async {
    final circle = _circles[circleId];
    if (circle == null) {
      throw const CircleRepositoryException('That circle no longer exists.');
    }

    final trimmedContent = content.trim();
    if (trimmedContent.isEmpty) {
      throw const CircleRepositoryException('Write something before posting.');
    }

    final updatedPosts = [
      CirclePost(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        author: author.trim().isEmpty ? 'You' : author.trim(),
        content: trimmedContent,
        createdAt: DateTime.now(),
      ),
      ..._currentPosts(circleId),
    ];

    _postsByCircle[circleId] = updatedPosts;
    _circles[circleId] = circle.copyWith(postCount: updatedPosts.length);

    _circlesController.add(_currentCircles());
    final postsController = _postsControllers[circleId];
    if (postsController != null && !postsController.isClosed) {
      postsController.add(updatedPosts);
    }
  }

  List<CircleSummary> _currentCircles() {
    return _circles.values.toList(growable: false);
  }

  List<CirclePost> _currentPosts(String circleId) {
    return List<CirclePost>.unmodifiable(_postsByCircle[circleId] ?? const []);
  }
}
