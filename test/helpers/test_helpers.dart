import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Helper class for setting up widget tests
class WidgetTestHelpers {
  /// Wrap a widget with necessary providers for testing
  static Widget wrapWithProviders(
    Widget child, {
    List<Override>? overrides,
  }) {
    return ProviderScope(
      overrides: overrides ?? [],
      child: MaterialApp(
        home: Scaffold(
          body: child,
        ),
      ),
    );
  }

  /// Create a basic test provider scope
  static ProviderScope createTestProviderScope({
    required Widget child,
    List<Override>? overrides,
  }) {
    return ProviderScope(
      overrides: overrides ?? [],
      child: child,
    );
  }

  /// Pump a widget with providers
  static Future<void> pumpWidgetWithProviders(
    WidgetTester tester,
    Widget child, {
    List<Override>? overrides,
  }) async {
    await tester.pumpWidget(wrapWithProviders(child, overrides: overrides));
  }

  /// Wait for all animations and async operations
  static Future<void> waitForAsync(WidgetTester tester) async {
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 100));
  }

  /// Find a widget by text and verify it exists
  static void expectToFindText(String text) {
    expect(find.text(text), findsOneWidget);
  }

  /// Find multiple widgets by text
  static void expectToFindNWidgets(String text, int count) {
    expect(find.text(text), findsNWidgets(count));
  }

  /// Verify a widget does not exist
  static void expectNotToFind(Finder finder) {
    expect(finder, findsNothing);
  }

  /// Tap a button by icon
  static Future<void> tapIcon(WidgetTester tester, IconData icon) async {
    await tester.tap(find.byIcon(icon));
    await tester.pumpAndSettle();
  }

  /// Tap a button by text
  static Future<void> tapText(WidgetTester tester, String text) async {
    await tester.tap(find.text(text));
    await tester.pumpAndSettle();
  }

  /// Enter text in a text field
  static Future<void> enterText(
    WidgetTester tester,
    Finder finder,
    String text,
  ) async {
    await tester.enterText(finder, text);
    await tester.pump();
  }

  /// Scroll to find a widget
  static Future<void> scrollUntilVisible(
    WidgetTester tester,
    Finder finder,
    Finder scrollable, {
    double delta = 100.0,
  }) async {
    await tester.scrollUntilVisible(
      finder,
      delta,
      scrollable: scrollable,
    );
  }

  /// Verify a circular progress indicator is shown
  static void expectLoadingIndicator() {
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  }

  /// Verify an error is displayed
  static void expectErrorDisplay() {
    expect(
      find.byWidgetPredicate(
        (widget) => widget is Text && widget.data?.contains('error') == true,
      ),
      findsWidgets,
    );
  }
}

/// Mock data builders for testing
class MockDataBuilders {
  /// Create a test date
  static DateTime testDate({int year = 2024, int month = 1, int day = 1}) {
    return DateTime(year, month, day);
  }

  /// Create a date range
  static List<DateTime> dateRange(DateTime start, int days) {
    return List.generate(
      days,
      (i) => start.add(Duration(days: i)),
    );
  }
}

/// Extension methods for testing
extension WidgetTesterExtensions on WidgetTester {
  /// Find by key string
  Finder findByKeyString(String key) {
    return find.byKey(Key(key));
  }

  /// Tap by key
  Future<void> tapByKey(String key) async {
    await tap(findByKeyString(key));
    await pumpAndSettle();
  }

  /// Wait for widget to appear
  Future<void> waitFor(Finder finder, {Duration timeout = const Duration(seconds: 5)}) async {
    final end = binding.clock.now().add(timeout);
    do {
      if (binding.clock.now().isAfter(end)) {
        throw Exception('Timed out waiting for $finder');
      }
      await pump(const Duration(milliseconds: 100));
    } while (finder.evaluate().isEmpty);
  }
}
