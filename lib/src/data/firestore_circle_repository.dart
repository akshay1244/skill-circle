import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/circle_models.dart';
import 'circle_repository.dart';

class FirestoreCircleRepository implements CircleRepository {
  FirestoreCircleRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _circlesCollection {
    return _firestore.collection('circles');
  }

  @override
  Stream<List<CircleSummary>> watchCircles() {
    return _circlesCollection.orderBy('name').snapshots().map((snapshot) {
      return snapshot.docs.map(_mapCircle).toList(growable: false);
    });
  }

  @override
  Stream<List<CirclePost>> watchPosts(String circleId) {
    return _circlesCollection
        .doc(circleId)
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(_mapPost).toList(growable: false));
  }

  @override
  Future<void> createPost({
    required String circleId,
    required String author,
    required String content,
  }) async {
    try {
      final trimmedContent = content.trim();
      if (trimmedContent.isEmpty) {
        throw const CircleRepositoryException(
          'Write something before posting.',
        );
      }

      final circleRef = _circlesCollection.doc(circleId);
      final postRef = circleRef.collection('posts').doc();
      final batch = _firestore.batch();

      batch.set(postRef, {
        'author': author.trim().isEmpty ? 'You' : author.trim(),
        'content': trimmedContent,
        'createdAt': FieldValue.serverTimestamp(),
      });
      batch.set(circleRef, {
        'postCount': FieldValue.increment(1),
      }, SetOptions(merge: true));

      await batch.commit();
    } on FirebaseException catch (error) {
      throw CircleRepositoryException(
        error.message ?? 'Could not publish the post right now.',
      );
    }
  }

  CircleSummary _mapCircle(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return CircleSummary(
      id: doc.id,
      name: data['name'] as String? ?? 'Untitled circle',
      description:
          data['description'] as String? ??
          'Add a description to help people understand this circle.',
      memberCount: (data['memberCount'] as num?)?.toInt() ?? 0,
      postCount: (data['postCount'] as num?)?.toInt() ?? 0,
      accentColorValue:
          (data['accentColorValue'] as num?)?.toInt() ??
          CircleSummary.fallbackAccentColorValue(doc.id),
    );
  }

  CirclePost _mapPost(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    final timestamp = data['createdAt'];

    return CirclePost(
      id: doc.id,
      author: data['author'] as String? ?? 'Anonymous',
      content: data['content'] as String? ?? '',
      createdAt: timestamp is Timestamp ? timestamp.toDate() : null,
    );
  }
}
