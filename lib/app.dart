import 'package:flutter/material.dart';

import 'src/data/circle_repository.dart';
import 'src/data/local_circle_repository.dart';
import 'src/screens/circles_home_screen.dart';
import 'src/theme/app_theme.dart';

class SkillCircleApp extends StatelessWidget {
  SkillCircleApp({
    CircleRepository? repository,
    this.dataStatusMessage,
    super.key,
  }) : repository = repository ?? LocalCircleRepository.seeded();

  final CircleRepository repository;
  final String? dataStatusMessage;

  @override
  Widget build(BuildContext context) {
    return CircleRepositoryScope(
      repository: repository,
      child: MaterialApp(
        title: 'Skill Circles',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: CirclesHomeScreen(dataStatusMessage: dataStatusMessage),
      ),
    );
  }
}

class CircleRepositoryScope extends InheritedWidget {
  const CircleRepositoryScope({
    required this.repository,
    required super.child,
    super.key,
  });

  final CircleRepository repository;

  static CircleRepository of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<CircleRepositoryScope>();
    assert(
      scope != null,
      'CircleRepositoryScope is missing from the widget tree.',
    );
    return scope!.repository;
  }

  @override
  bool updateShouldNotify(CircleRepositoryScope oldWidget) {
    return repository != oldWidget.repository;
  }
}
