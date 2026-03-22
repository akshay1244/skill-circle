import 'package:flutter/material.dart';

import '../widgets/brand_header.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({required this.email, super.key});

  static const routeName = '/home';

  final String email;

  String get firstName {
    final localPart = email.split('@').first;
    if (localPart.isEmpty) {
      return 'there';
    }

    final cleaned = localPart.replaceAll(RegExp(r'[^a-zA-Z]'), ' ').trim();
    if (cleaned.isEmpty) {
      return 'there';
    }

    final firstChunk = cleaned.split(RegExp(r'\s+')).first;
    return '${firstChunk[0].toUpperCase()}${firstChunk.substring(1)}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Skill Circle'),
        actions: [
          IconButton(
            tooltip: 'Log out',
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                LoginScreen.routeName,
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BrandHeader(
                    title: 'Hello, $firstName',
                    subtitle:
                        'You are signed in and ready to jump back into your workspace.',
                  ),
                  const SizedBox(height: 28),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final infoCards = [
                        _InfoCard(
                          icon: Icons.person_outline_rounded,
                          label: 'Signed in as',
                          value: email,
                        ),
                        const _InfoCard(
                          icon: Icons.check_circle_outline_rounded,
                          label: 'Status',
                          value: 'Active session',
                        ),
                      ];

                      if (constraints.maxWidth < 560) {
                        return Column(
                          children: [
                            for (var index = 0; index < infoCards.length; index++) ...[
                              infoCards[index],
                              if (index < infoCards.length - 1)
                                const SizedBox(height: 16),
                            ],
                          ],
                        );
                      }

                      return Row(
                        children: [
                          Expanded(child: infoCards[0]),
                          const SizedBox(width: 16),
                          Expanded(child: infoCards[1]),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'What you have now',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const _FeatureTile(
                            icon: Icons.login_rounded,
                            title: 'Simple authentication flow',
                            subtitle:
                                'Login validates user input and navigates cleanly into the app.',
                          ),
                          const _FeatureTile(
                            icon: Icons.route_rounded,
                            title: 'Clear navigation',
                            subtitle:
                                'Named routes keep the screen structure easy to grow.',
                          ),
                          const _FeatureTile(
                            icon: Icons.auto_awesome_rounded,
                            title: 'Modern visual language',
                            subtitle:
                                'Material 3 styling, rounded cards, and soft gradients create a polished feel.',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  const _FeatureTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
