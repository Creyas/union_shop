import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/pages/login_signup.dart';

void main() {
  group('Login Signup Page Tests', () {
    Widget createTestWidget() {
      return const MaterialApp(home: LoginSignupPage());
    }

    testWidgets('should display login signup page with basic elements', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Check that basic UI elements are present
      expect(find.byType(LoginSignupPage), findsOneWidget);
      expect(find.byType(Form), findsOneWidget);
    });

    testWidgets('should display header with back button', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Check that header widget is present
      expect(find.byType(AppBar), findsAny);
    });

    testWidgets('should display footer', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Check that footer widget is present
      expect(find.text('Placeholder Footer'), findsOneWidget);
    });

    testWidgets('should display login form by default', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Check for login title and fields
      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('LOGIN'), findsOneWidget);
      expect(find.text("Don't have an account? "), findsOneWidget);
      expect(find.text('Sign Up'), findsOneWidget);
    });

    testWidgets('should display forgot password link in login mode', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Check for forgot password link
      expect(find.text('Forgot Password?'), findsOneWidget);
    });

    testWidgets('should toggle to signup form', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Tap on Sign Up button
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      // Check for signup title and additional fields
      expect(find.text('Create Account'), findsOneWidget);
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
      expect(find.text('CREATE ACCOUNT'), findsOneWidget);
      expect(find.text('Already have an account? '), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('should not display forgot password in signup mode', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Toggle to signup
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      // Check that forgot password is not present
      expect(find.text('Forgot Password?'), findsNothing);
    });

    testWidgets('should display email and password fields', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Check for text form fields
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.byIcon(Icons.email), findsOneWidget);
      expect(find.byIcon(Icons.lock), findsOneWidget);
    });

    testWidgets('should display password visibility toggle', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Check for visibility toggle icons
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

    testWidgets('should toggle password visibility', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Find and tap the visibility toggle
      final visibilityToggle = find.byIcon(Icons.visibility_off).first;
      await tester.tap(visibilityToggle);
      await tester.pump();

      // Check that icon changed
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('should display login button', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Check for login button
      expect(find.widgetWithText(ElevatedButton, 'LOGIN'), findsOneWidget);
    });

    testWidgets('should display all signup fields when in signup mode', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Toggle to signup
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      // Check for all signup fields
      expect(find.byType(TextFormField), findsNWidgets(4));
      expect(find.byIcon(Icons.person), findsOneWidget);
      expect(find.byIcon(Icons.email), findsOneWidget);
      expect(find.byIcon(Icons.lock), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    });

    testWidgets('should be scrollable', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Check that SingleChildScrollView is present
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('should show forgot password dialog when tapped', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Tap forgot password button
      await tester.tap(find.text('Forgot Password?'));
      await tester.pumpAndSettle();

      // Check for dialog
      expect(find.text('Reset Password'), findsOneWidget);
      expect(
        find.text('Enter your email to receive a password reset link.'),
        findsOneWidget,
      );
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Send Reset Link'), findsOneWidget);
    });

    testWidgets('should clear fields when toggling between login and signup',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Enter text in email field
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'test@example.com',
      );
      await tester.pump();

      // Toggle to signup
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      // Toggle back to login
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Fields should be cleared (form is reset)
      expect(find.text('test@example.com'), findsNothing);
    });
  });
}