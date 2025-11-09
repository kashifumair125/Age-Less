import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:age_less/core/utils/async_value_helpers.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('ErrorDisplay Widget', () {
    testWidgets('should display error message', (tester) async {
      final error = Exception('Test error message');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorDisplay(error: error),
          ),
        ),
      );

      expect(find.text('Oops! Something went wrong'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Test error message'), findsOneWidget);
    });

    testWidgets('should display retry button when onRetry is provided', (tester) async {
      var retryTapped = false;
      final error = Exception('Test error');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorDisplay(
              error: error,
              onRetry: () => retryTapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Try Again'), findsOneWidget);

      await tester.tap(find.text('Try Again'));
      await tester.pump();

      expect(retryTapped, isTrue);
    });

    testWidgets('should not display retry button when onRetry is null', (tester) async {
      final error = Exception('Test error');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorDisplay(error: error),
          ),
        ),
      );

      expect(find.text('Try Again'), findsNothing);
    });
  });

  group('LoadingDisplay Widget', () {
    testWidgets('should display loading indicator', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingDisplay(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display message when provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingDisplay(message: 'Loading data...'),
          ),
        ),
      );

      expect(find.text('Loading data...'), findsOneWidget);
    });
  });

  group('EmptyDisplay Widget', () {
    testWidgets('should display empty state with title', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyDisplay(title: 'No data found'),
          ),
        ),
      );

      expect(find.text('No data found'), findsOneWidget);
      expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
    });

    testWidgets('should display message when provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyDisplay(
              title: 'No items',
              message: 'Add items to get started',
            ),
          ),
        ),
      );

      expect(find.text('No items'), findsOneWidget);
      expect(find.text('Add items to get started'), findsOneWidget);
    });

    testWidgets('should display custom icon when provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyDisplay(
              title: 'No notifications',
              icon: Icons.notifications_outlined,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
    });

    testWidgets('should display action button when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyDisplay(
              title: 'No data',
              action: ElevatedButton(
                onPressed: () {},
                child: const Text('Add Data'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Add Data'), findsOneWidget);
    });
  });
}
