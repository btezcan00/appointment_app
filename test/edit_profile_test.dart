import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appointment_app/pages/edit_profile_page.dart';
import 'package:appointment_app/models/user_profile.dart';

void main() {
  group('EditProfilePage', () {
    late UserProfile testProfile;

    setUp(() {
      testProfile = UserProfile(
        name: 'John Doe',
        age: 30,
        profilePhotoUrl: '',
        email: 'john@example.com',
        phone: '1234567890',
        address: '123 Main St',
      );
    });

    testWidgets('should display edit profile page with correct title',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: EditProfilePage(currentProfile: testProfile),
        ),
      );

      expect(find.text('Edit Profile'), findsOneWidget);
    });

    testWidgets('should display all form fields with current profile data',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: EditProfilePage(currentProfile: testProfile),
        ),
      );

      // Verify that all fields are displayed with correct initial values
      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('30'), findsOneWidget);
      expect(find.text('john@example.com'), findsOneWidget);
      expect(find.text('1234567890'), findsOneWidget);
      expect(find.text('123 Main St'), findsOneWidget);
    });

    testWidgets('should display all field labels', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: EditProfilePage(currentProfile: testProfile),
        ),
      );

      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Age'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Phone'), findsOneWidget);
      expect(find.text('Address'), findsOneWidget);
    });

    testWidgets('should display save and cancel buttons',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: EditProfilePage(currentProfile: testProfile),
        ),
      );

      expect(find.text('Save Changes'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('should have correct icons for each field',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: EditProfilePage(currentProfile: testProfile),
        ),
      );

      expect(find.byIcon(Icons.person_outline), findsOneWidget);
      expect(find.byIcon(Icons.cake_outlined), findsOneWidget);
      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
      expect(find.byIcon(Icons.phone_outlined), findsOneWidget);
      expect(find.byIcon(Icons.location_on_outlined), findsOneWidget);
      expect(find.byIcon(Icons.camera_alt), findsOneWidget);
    });

    testWidgets('should allow editing name field', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: EditProfilePage(currentProfile: testProfile),
        ),
      );

      final nameField = find.widgetWithText(TextFormField, 'John Doe');
      expect(nameField, findsOneWidget);

      // Enter new text
      await tester.enterText(nameField, 'Jane Smith');
      await tester.pump();

      expect(find.text('Jane Smith'), findsOneWidget);
    });

    testWidgets('should allow editing age field', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: EditProfilePage(currentProfile: testProfile),
        ),
      );

      final ageField = find.widgetWithText(TextFormField, '30');
      expect(ageField, findsOneWidget);

      await tester.enterText(ageField, '35');
      await tester.pump();

      expect(find.text('35'), findsOneWidget);
    });

    testWidgets('should allow editing email field', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: EditProfilePage(currentProfile: testProfile),
        ),
      );

      final emailField = find.widgetWithText(TextFormField, 'john@example.com');
      expect(emailField, findsOneWidget);

      await tester.enterText(emailField, 'jane@example.com');
      await tester.pump();

      expect(find.text('jane@example.com'), findsOneWidget);
    });

    testWidgets('should allow editing phone field', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: EditProfilePage(currentProfile: testProfile),
        ),
      );

      final phoneField = find.widgetWithText(TextFormField, '1234567890');
      expect(phoneField, findsOneWidget);

      await tester.enterText(phoneField, '9876543210');
      await tester.pump();

      expect(find.text('9876543210'), findsOneWidget);
    });

    testWidgets('should allow editing address field', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: EditProfilePage(currentProfile: testProfile),
        ),
      );

      final addressField = find.widgetWithText(TextFormField, '123 Main St');
      expect(addressField, findsOneWidget);

      await tester.enterText(addressField, '456 Oak Ave');
      await tester.pump();

      expect(find.text('456 Oak Ave'), findsOneWidget);
    });

    testWidgets('profile photo has CircleAvatar', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: EditProfilePage(currentProfile: testProfile),
        ),
      );

      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('form should have GlobalKey', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: EditProfilePage(currentProfile: testProfile),
        ),
      );

      expect(find.byType(Form), findsOneWidget);
    });

    testWidgets('all text fields should be TextFormField',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: EditProfilePage(currentProfile: testProfile),
        ),
      );

      // Should have 5 TextFormFields (name, age, email, phone, address)
      expect(find.byType(TextFormField), findsNWidgets(5));
    });
  });
}
