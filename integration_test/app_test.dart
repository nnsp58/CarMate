import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:rideon/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> forcedDelay(WidgetTester tester, {int seconds = 2}) async {
    await Future.delayed(Duration(seconds: seconds));
    await tester.pump();
  }

  group('RideOn Master Integration Test', () {
    testWidgets('Complete E2E Real User Flow', (WidgetTester tester) async {
      app.main();
      
      debugPrint('Waiting for Splash Screen...');
      await forcedDelay(tester, seconds: 5); // Wait for Splash and Routing

      // ===================================
      // 1. AUTH FLOW
      // ===================================
      debugPrint('Testing Auth Flow...');
      
      final loginBtn = find.byKey(const Key('welcome_login_button'));
      if (loginBtn.evaluate().isNotEmpty) {
        await tester.tap(loginBtn);
        await forcedDelay(tester);

        final phoneField = find.byType(TextFormField).first;
        await tester.enterText(phoneField, '9900000001'); // pax1 mock user
        await forcedDelay(tester);

        final submitLogin = find.byKey(const Key('login_button'));
        if (submitLogin.evaluate().isNotEmpty) {
          await tester.tap(submitLogin);
        } else {
          await tester.tap(find.text('Login').last);
        }
        await forcedDelay(tester, seconds: 3);
        
        // Wait for OTP/Home routing
        await forcedDelay(tester, seconds: 4);
      } else {
        debugPrint('Skipping Login, likely already logged in!');
      }

      // ===================================
      // 2. RIDE SEARCH & BOOKING LOOP
      // ===================================
      debugPrint('Testing Search & Booking...');
      const int loopCount = 20;

      for (int i = 0; i < loopCount; i++) {
        debugPrint('Running Stability Loop iteration: \$i');

        final fromField = find.byKey(const Key('search_from_field'));
        final toField = find.byKey(const Key('search_to_field'));
        final searchBtn = find.byKey(const Key('search_button'));

        if (fromField.evaluate().isNotEmpty && toField.evaluate().isNotEmpty) {
           await tester.enterText(fromField, 'Delhi');
           await tester.enterText(toField, 'Jaipur');
           await forcedDelay(tester, seconds: 1);
           
           await tester.tap(searchBtn);
           await forcedDelay(tester, seconds: 4); // Wait for API

           final rideCard = find.byKey(const Key('search_ride_card'));
           if (rideCard.evaluate().isNotEmpty) {
              await tester.tap(rideCard.first);
              await forcedDelay(tester, seconds: 2);
              
              final bookBtn = find.byKey(const Key('book_ride_button'));
              if (bookBtn.evaluate().isNotEmpty) {
                 await tester.tap(bookBtn);
                 await forcedDelay(tester, seconds: 3); // Booked!
              }
              // Press back to reset for loop
              final backBtn = find.byIcon(Icons.arrow_back);
              if (backBtn.evaluate().isNotEmpty) {
                 await tester.tap(backBtn);
                 await forcedDelay(tester, seconds: 1);
              }
           }
        }
      }

      // ===================================
      // 3. SOS CRITICAL TEST
      // ===================================
      debugPrint('Testing SOS Button...');
      final sosBtn = find.byKey(const Key('sos_button'));
      if (sosBtn.evaluate().isNotEmpty) {
         await tester.longPress(sosBtn);
         await forcedDelay(tester, seconds: 2);

         final cancelSos = find.text('Cancel SOS');
         if (cancelSos.evaluate().isNotEmpty) {
           await tester.tap(cancelSos.first);
           await forcedDelay(tester);
         }
      }

      debugPrint('Master Test Script Completed Successfully! Holding Screen Open...');
      await forcedDelay(tester, seconds: 10000); // 🚀 HOLD THE SCREEN OPEN INDEFINITELY
    });
  });
}
