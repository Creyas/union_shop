import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/pages/all_products_page.dart';

void main() {
  group('All Products Page Tests', () {
    Widget createTestWidget() {
      return const MaterialApp(home: AllProductsPage());
    }

    testWidgets('should display all products page with basic elements', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Check that basic UI elements are present
      expect(find.byType(AllProductsPage), findsOneWidget);
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

    testWidgets('should display product grid or list', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Check for common grid/list widgets
      final gridFinder = find.byType(GridView);
      final listFinder = find.byType(ListView);

      // At least one should be present
      expect(
        gridFinder.evaluate().isNotEmpty || listFinder.evaluate().isNotEmpty,
        true,
      );
    });

    testWidgets('should display search or filter options if present', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Check for search icon if present
      final searchIcon = find.byIcon(Icons.search);
      final filterIcon = find.byIcon(Icons.filter_list);

      // These are optional, so we just verify they exist if implemented
      expect(searchIcon, findsAny);
      expect(filterIcon, findsAny);
    });
  });
}
