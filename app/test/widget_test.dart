// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:app/Pages/Home.dart';
import 'package:app/Pages/Startup/Register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app/main.dart';

void main() {
  /*
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
  */

  testWidgets('comment deletion test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: home(),
    ));

    final comment_button = find.byKey(ValueKey("comment_button"));

    await tester.tap(comment_button.first);

    await tester.pump();

    final comment_delete = find.byKey(ValueKey("comment_delete"));

    await tester.tap(comment_delete.first);

    await tester.pump();

    expect(find.byKey(ValueKey("comment_button")), findsNWidgets(4));
  });
}
