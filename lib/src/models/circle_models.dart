import 'package:flutter/material.dart';

class CircleSummary {
  const CircleSummary({
    required this.id,
    required this.name,
    required this.description,
    required this.memberCount,
    required this.postCount,
    required this.accentColorValue,
  });

  final String id;
  final String name;
  final String description;
  final int memberCount;
  final int postCount;
  final int accentColorValue;

  Color get accentColor => Color(accentColorValue);

  String get membersLabel => '$memberCount members';

  CircleSummary copyWith({
    String? id,
    String? name,
    String? description,
    int? memberCount,
    int? postCount,
    int? accentColorValue,
  }) {
    return CircleSummary(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      memberCount: memberCount ?? this.memberCount,
      postCount: postCount ?? this.postCount,
      accentColorValue: accentColorValue ?? this.accentColorValue,
    );
  }

  static int fallbackAccentColorValue(String seed) {
    const palette = [
      0xFFECE8FF,
      0xFFE4F7F0,
      0xFFFFF1DD,
      0xFFFFE3E3,
      0xFFE3F0FF,
    ];

    return palette[seed.hashCode.abs() % palette.length];
  }
}

class CirclePost {
  const CirclePost({
    required this.id,
    required this.author,
    required this.content,
    required this.createdAt,
  });

  final String id;
  final String author;
  final String content;
  final DateTime? createdAt;

  String get timeAgo {
    final timestamp = createdAt;
    if (timestamp == null) {
      return 'Just now';
    }

    final difference = DateTime.now().difference(timestamp);
    if (difference.inMinutes < 1) {
      return 'Just now';
    }
    if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    }
    if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    }

    return '${difference.inDays}d ago';
  }
}
