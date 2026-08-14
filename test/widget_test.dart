import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jungle_monkey_run/widgets/jungle_button.dart';

void main() {
  testWidgets('Jungle button exposes and triggers its action', (
    WidgetTester tester,
  ) async {
    var pressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: JungleButton(
            label: 'PLAY',
            primary: true,
            onPressed: () => pressed = true,
          ),
        ),
      ),
    );

    expect(find.text('PLAY'), findsOneWidget);
    await tester.tap(find.text('PLAY'));
    expect(pressed, isTrue);
  });
}
