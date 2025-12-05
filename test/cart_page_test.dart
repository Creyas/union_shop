import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/pages/cart_page.dart';
import 'package:union_shop/providers/cart_provider.dart';

void main() {
  group('Cart Page Tests', () {
    Widget createTestWidget() {
      return ChangeNotifierProvider(
        create: (_) => CartProvider(),
        child: const MaterialApp(home: CartPage()),
      );
    }

    testWidgets('should display cart page with basic elements', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Check that basic UI elements are present
      expect(find.byType(CartPage), findsOneWidget);
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

    testWidgets('should display empty cart message when cart is empty', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Check for empty cart message or icon
      expect(find.text('Your cart is empty'), findsAny);
    });

    testWidgets('should be scrollable', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Check that SingleChildScrollView or ListView is present
      final scrollFinder = find.byType(SingleChildScrollView);
      final listFinder = find.byType(ListView);

      expect(
        scrollFinder.evaluate().isNotEmpty || listFinder.evaluate().isNotEmpty,
        true,
      );
    });

    testWidgets('should display total price section', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Check for price-related text
      expect(find.textContaining('Total'), findsAny);
      expect(find.textContaining('£'), findsAny);
    });

    testWidgets('should display checkout button', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Check for checkout button
      expect(find.textContaining('Checkout'), findsAny);
    });
  });
}
