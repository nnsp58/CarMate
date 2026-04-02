import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideon/screens/publish/publish_ride_screen.dart';
import 'package:rideon/providers/auth_provider.dart';
import 'package:rideon/models/user_model.dart';
import 'package:rideon/providers/ride_provider.dart';

void main() {
  testWidgets('PublishRideScreen renders correctly', (WidgetTester tester) async {
    // Set a larger surface size for the test to avoid overflow and scrolling issues
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final mockUser = UserModel(
      id: 'test-user-id',
      fullName: 'Test User',
      email: 'test@example.com',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      setupComplete: true,
      docVerificationStatus: 'approved',
      photoUrl: 'http://example.com/photo.jpg',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentUserProvider.overrideWith((ref) => mockUser),
          publishRideProvider.overrideWith((ref) => PublishRideNotifier(ref)),
        ],
        child: const MaterialApp(
          home: PublishRideScreen(),
        ),
      ),
    );

    // Initial load and wait for the Future.delayed(Duration.zero) in initState
    await tester.pump();
    await tester.pumpAndSettle();

    // Verify the screen title
    expect(find.text('Publish a Ride'), findsOneWidget);
    
    // Check for "Route Details" section
    expect(find.text('Route Details'), findsOneWidget);
    
    // Check for "From" and "To" fields
    expect(find.text('From'), findsOneWidget);
    expect(find.text('To'), findsOneWidget);
    
    // Check for "Date & Time" section
    expect(find.text('Date & Time'), findsOneWidget);
    
    // Check for "Publish Ride" button text
    expect(find.text('Publish Ride'), findsOneWidget);
  });

  testWidgets('PublishRideScreen form validation', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final mockUser = UserModel(
      id: 'test-user-id',
      fullName: 'Test User',
      email: 'test@example.com',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      setupComplete: true,
      docVerificationStatus: 'approved',
      photoUrl: 'http://example.com/photo.jpg',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentUserProvider.overrideWith((ref) => mockUser),
        ],
        child: const MaterialApp(
          home: PublishRideScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.pumpAndSettle();

    // Click Publish button without filling fields
    final publishButton = find.text('Publish Ride');
    await tester.ensureVisible(publishButton);
    await tester.tap(publishButton);
    await tester.pumpAndSettle();

    // Should see "Required" validation messages for Price field
    expect(find.text('Required'), findsWidgets);
  });
}
