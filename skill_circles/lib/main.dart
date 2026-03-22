import 'package:flutter/material.dart';

void main() {
  runApp(const SkillCirclesApp());
}

class SkillCirclesApp extends StatelessWidget {
  const SkillCirclesApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF5B6CFF),
      brightness: Brightness.light,
    );

    return MaterialApp(
      title: 'Skill Circles',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: colorScheme,
        scaffoldBackgroundColor: const Color(0xFFF6F7FB),
        appBarTheme: const AppBarTheme(centerTitle: false),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
          ),
        ),
      ),
      home: const CirclesHomeScreen(),
    );
  }
}

class Circle {
  Circle({
    required this.name,
    required this.description,
    required this.members,
    required this.posts,
    required this.accentColor,
  });

  final String name;
  final String description;
  final String members;
  final List<Post> posts;
  final Color accentColor;
}

class Post {
  Post({
    required this.author,
    required this.content,
    required this.timeAgo,
  });

  final String author;
  final String content;
  final String timeAgo;
}

class CirclesHomeScreen extends StatefulWidget {
  const CirclesHomeScreen({super.key});

  @override
  State<CirclesHomeScreen> createState() => _CirclesHomeScreenState();
}

class _CirclesHomeScreenState extends State<CirclesHomeScreen> {
  final List<Circle> _circles = [
    Circle(
      name: 'Design Circle',
      description: 'Share UI inspiration, feedback, and quick critiques.',
      members: '128 members',
      accentColor: const Color(0xFFECE8FF),
      posts: [
        Post(
          author: 'Mia',
          content: 'Just uploaded a new onboarding flow. Would love feedback on the hierarchy.',
          timeAgo: '12m ago',
        ),
        Post(
          author: 'Jordan',
          content: 'Reminder: today\'s mini-review is focused on accessibility wins.',
          timeAgo: '1h ago',
        ),
      ],
    ),
    Circle(
      name: 'Product Builders',
      description: 'Talk roadmap ideas, validation, and product experiments.',
      members: '214 members',
      accentColor: const Color(0xFFE4F7F0),
      posts: [
        Post(
          author: 'Alex',
          content: 'What\'s your favorite way to test demand before writing production code?',
          timeAgo: '24m ago',
        ),
        Post(
          author: 'Sam',
          content: 'We cut our launch checklist from 18 steps to 7 and shipped faster.',
          timeAgo: '2h ago',
        ),
      ],
    ),
    Circle(
      name: 'Flutter Friends',
      description: 'Exchange widgets, patterns, and performance tips.',
      members: '96 members',
      accentColor: const Color(0xFFFFF1DD),
      posts: [
        Post(
          author: 'Taylor',
          content: 'Hot tip: use SliverList when you want more flexible scrolling layouts.',
          timeAgo: '9m ago',
        ),
        Post(
          author: 'Chris',
          content: 'Sharing a neat animation pattern for tappable cards later today.',
          timeAgo: '3h ago',
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: const Text('Your Circles'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.primary.withValues(alpha: 0.78),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Find your people.',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Jump into focused communities, read the latest posts, and keep the conversation moving.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.92),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Featured circles',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 14),
            ..._circles.map(
              (circle) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: CircleCard(
                  circle: circle,
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => CircleDetailScreen(circle: circle),
                      ),
                    );
                    if (mounted) {
                      setState(() {});
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CircleCard extends StatelessWidget {
  const CircleCard({
    super.key,
    required this.circle,
    required this.onTap,
  });

  final Circle circle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: circle.accentColor,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.people_alt_rounded),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      circle.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      circle.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${circle.members} • ${circle.posts.length} posts',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

class CircleDetailScreen extends StatefulWidget {
  const CircleDetailScreen({
    super.key,
    required this.circle,
  });

  final Circle circle;

  @override
  State<CircleDetailScreen> createState() => _CircleDetailScreenState();
}

class _CircleDetailScreenState extends State<CircleDetailScreen> {
  Future<void> _createPost() async {
    final controller = TextEditingController();

    final newPost = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFFF6F7FB),
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create a post',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: 'Share an update, ask a question, or start a conversation...',
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.of(context).pop(controller.text.trim());
                    },
                    child: const Text('Post to circle'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    controller.dispose();

    if (newPost == null || newPost.isEmpty) {
      return;
    }

    setState(() {
      widget.circle.posts.insert(
        0,
        Post(
          author: 'You',
          content: newPost,
          timeAgo: 'Just now',
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: Text(widget.circle.name),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createPost,
        icon: const Icon(Icons.edit_rounded),
        label: const Text('Create post'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 96),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: widget.circle.accentColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.forum_rounded),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.circle.name,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.circle.members,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.black54,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.circle.description,
                    style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Recent posts',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 14),
            ...widget.circle.posts.map(
              (post) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: PostCard(post: post),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.post,
  });

  final Post post;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.14),
                foregroundColor: theme.colorScheme.primary,
                child: Text(post.author.characters.first),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.author,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      post.timeAgo,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            post.content,
            style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }
}
