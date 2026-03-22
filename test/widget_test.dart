import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skill_circles/app.dart';

void main() {
  testWidgets('user can browse circles and create a post', (tester) async {
    await tester.pumpWidget(SkillCircleApp());
    await tester.pumpAndSettle();

    expect(find.text('Your Circles'), findsOneWidget);
    expect(find.text('Featured circles'), findsOneWidget);
    expect(find.text('Design Circle'), findsOneWidget);

    await tester.tap(find.text('Design Circle'));
    await tester.pumpAndSettle();

    expect(find.text('Recent posts'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);

    await tester.tap(find.widgetWithText(FloatingActionButton, 'Create post'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(TextField),
      'Excited to join this circle and share ideas.',
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Post to circle'));
    await tester.pumpAndSettle();

    expect(
      find.text('Excited to join this circle and share ideas.'),
      findsOneWidget,
    );
    expect(find.text('You'), findsOneWidget);
  });
}
