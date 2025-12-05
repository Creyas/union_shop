import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/pages/freshers_sale_page.dart';

void main() {
  group('Freshers Sale Page Tests', () {
    Widget createTestWidget() {
      return const MaterialApp(home: FreshersSalePage());
    }

    testWidgets('should display freshers sale page with basic elements', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Check that basic UI elements are present
      expect(find.byType(FreshersSalePage), findsOneWidget);
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

    testWidgets('should display sale banner or title', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Check for sale-related text
      expect(find.textContaining('Freshers'), findsAny);
      expect(find.textContaining('Sale'), findsAny);
    });

    testWidgets('should display sale products grid or list', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Check for common grid/list widgets
      final gridFinder = find.byType(GridView);
      final listFinder = find.byType(ListView);

      // At least one should be present for displaying products
      expect(
        gridFinder.evaluate().isNotEmpty || listFinder.evaluate().isNotEmpty,
        true,
      );
    });

    testWidgets('should display discount or price information', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Check for price indicators
      expect(find.textContaining('£'), findsAny);
    });

    testWidgets('should display promotional content', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Check that promotional text or images are displayed
      expect(find.byType(Text), findsWidgets);
    });
  });
}
