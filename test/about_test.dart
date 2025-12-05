import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/pages/about.dart';

void main() {
  group('About Page Tests', () {
    Widget createTestWidget() {
      return const MaterialApp(home: AboutPage());
    }

    testWidgets('should display about page with basic elements', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Check that basic UI elements are present
      expect(find.byType(AboutPage), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should display header', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Check that header is present
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should display footer', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Check that footer widget is present
      expect(find.text('Placeholder Footer'), findsOneWidget);
    });

    testWidgets('should be scrollable', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Check that SingleChildScrollView is present
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('should display about content', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Check for any Text widgets (adjust based on your actual content)
      expect(find.byType(Text), findsWidgets);
    });
  });
}
