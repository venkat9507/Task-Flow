// Basic Flutter widget test for TaskFlow
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:taskflow/main.dart';

void main() {
  testWidgets('App should start and display TaskFlow title', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: TaskFlowApp()));

    // Wait for any async operations
    await tester.pumpAndSettle();

    // Verify that the app title is displayed
    expect(find.text('TaskFlow'), findsOneWidget);
  });
}
