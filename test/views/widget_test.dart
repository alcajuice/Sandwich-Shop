// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../lib/main.dart';

void main() {
  String extractTextFromWidget(Widget w) {
    if (w is Text) return w.data ?? w.textSpan?.toPlainText() ?? '';
    return '';
  }

  testWidgets('Switch toggles between six-inch and footlong', (
    WidgetTester tester,
  ) async {
    // Build the app
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    // Find the order preview Text (the widget that includes 'sandwich(es):')
    final previewFinder = find.byWidgetPredicate((w) {
      final s = extractTextFromWidget(w);
      return s.contains('sandwich(es):');
    });

    // The preview should exist and initially reference 'footlong'
    expect(previewFinder, findsOneWidget);
    var previewTextWidget = tester.widget<Text>(previewFinder);
    var preview = extractTextFromWidget(previewTextWidget);
    expect(preview.contains('footlong'), isTrue);
    expect(preview.contains('six-inch'), isFalse);

    // Toggle the sandwich size switch (use key to uniquely identify it)
    final switchFinder = find.byKey(const Key('sandwich_size_switch'));
    expect(switchFinder, findsOneWidget);
    await tester.tap(switchFinder);
    await tester.pumpAndSettle();

    // After toggling, the preview should reference 'six-inch'
    previewTextWidget = tester.widget<Text>(previewFinder);
    preview = extractTextFromWidget(previewTextWidget);
    expect(preview.contains('six-inch'), isTrue);
    expect(preview.contains('footlong'), isFalse);
  });

  testWidgets('Add button increases quantity', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    // Verify initial display shows 0 white footlong (default)
    final zeroFinder = find.byWidgetPredicate(
      (w) => w is Text && (w.data ?? '').contains('0 white footlong'),
    );
    final oneFinder = find.byWidgetPredicate(
      (w) => w is Text && (w.data ?? '').contains('1 white footlong'),
    );

    expect(zeroFinder, findsOneWidget);
    expect(oneFinder, findsNothing);

    // Tap the Add button and rebuild
    final addButton = find.text('Add');
    expect(addButton, findsOneWidget);
    await tester.tap(addButton);
    await tester.pumpAndSettle();

    // Now the display should show quantity 1
    expect(zeroFinder, findsNothing);
    expect(oneFinder, findsOneWidget);
  });

  testWidgets('Both switches toggle independently', (
    WidgetTester tester,
  ) async {
    // Build the app and wait for it to settle
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    final sizeSwitchFinder = find.byKey(const Key('sandwich_size_switch'));
    final toastedSwitchFinder = find.byKey(const Key('toasted_switch'));

    expect(sizeSwitchFinder, findsOneWidget);
    expect(toastedSwitchFinder, findsOneWidget);

    // Read initial values
    var sizeSwitch = tester.widget<Switch>(sizeSwitchFinder);
    var toastedSwitch = tester.widget<Switch>(toastedSwitchFinder);

    // Defaults from the app: size is footlong (true), toasted is false
    expect(sizeSwitch.value, isTrue);
    expect(toastedSwitch.value, isFalse);

    // Toggle size switch -> should change displayed sandwich type
    await tester.tap(sizeSwitchFinder);
    await tester.pumpAndSettle();

    // Verify switch widget value updated
    sizeSwitch = tester.widget<Switch>(sizeSwitchFinder);
    expect(sizeSwitch.value, isFalse);

    // Verify the preview text now shows six-inch
    final previewFinder = find.byWidgetPredicate((w) {
      if (w is Text)
        return (w.data ?? w.textSpan?.toPlainText() ?? '').contains(
          'sandwich(es):',
        );
      return false;
    });
    final previewText = tester.widget<Text>(previewFinder);
    final preview =
        previewText.data ?? previewText.textSpan?.toPlainText() ?? '';
    expect(preview.contains('six-inch'), isTrue);

    // Toggle toasted switch -> should flip its boolean value
    await tester.tap(toastedSwitchFinder);
    await tester.pumpAndSettle();

    toastedSwitch = tester.widget<Switch>(toastedSwitchFinder);
    expect(toastedSwitch.value, isTrue);
  });
}
