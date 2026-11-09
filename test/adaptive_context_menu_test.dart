import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:adaptive_context_menu/adaptive_context_menu.dart';

void main() {
  testWidgets('renders child widget in default state',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: AdaptiveContextMenu(
              actions: [
                AdaptiveContextAction(
                  title: 'Copy',
                  icon: Icons.copy,
                  onPressed: () {},
                ),
              ],
              child: const Text('Target Item'),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Target Item'), findsOneWidget);
    expect(find.text('Copy'), findsNothing);
  });

  testWidgets('opens context menu on long press and executes action callback',
      (WidgetTester tester) async {
    bool actionCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: AdaptiveContextMenu(
              actions: [
                AdaptiveContextAction(
                  title: 'Bookmark',
                  icon: Icons.bookmark,
                  onPressed: () => actionCalled = true,
                ),
                const AdaptiveContextDivider(),
                AdaptiveContextAction(
                  title: 'Delete',
                  icon: Icons.delete,
                  isDestructive: true,
                  onPressed: () {},
                ),
              ],
              child: Container(
                width: 120,
                height: 50,
                color: Colors.blue,
                child: const Center(child: Text('Hold Me')),
              ),
            ),
          ),
        ),
      ),
    );

    // Trigger long press
    await tester.longPress(find.text('Hold Me'));
    await tester.pumpAndSettle();

    // Verify menu items are visible
    expect(find.text('Bookmark'), findsOneWidget);
    expect(find.text('Delete'), findsOneWidget);

    // Tap action
    await tester.tap(find.text('Bookmark'));
    await tester.pumpAndSettle();

    expect(actionCalled, isTrue);
    expect(find.text('Bookmark'), findsNothing);
  });

  testWidgets('dismisses menu on tapping backdrop',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: AdaptiveContextMenu(
              actions: [
                AdaptiveContextAction(
                  title: 'Share',
                  onPressed: () {},
                ),
              ],
              child: const Text('Message Bubble'),
            ),
          ),
        ),
      ),
    );

    await tester.longPress(find.text('Message Bubble'));
    await tester.pumpAndSettle();

    expect(find.text('Share'), findsOneWidget);

    // Tap on top left corner (backdrop)
    await tester.tapAt(const Offset(20, 20));
    await tester.pumpAndSettle();

    expect(find.text('Share'), findsNothing);
  });
}
