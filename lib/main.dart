import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'app.dart';
import 'services/supabase_service.dart';

// ✅ FIX: Supabase ab main() mein initialize hota hai — build() se pehle.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await dotenv.load(fileName: ".env");

  // OneSignal Initialization (Disable for Web)
  if (!kIsWeb) {
    try {
      OneSignal.initialize(dotenv.env['ONESIGNAL_APP_ID'] ?? "");
      OneSignal.Notifications.requestPermission(true);
    } catch (e) {
      debugPrint('OneSignal init error: $e');
    }
  }

  if (kIsWeb) {
    usePathUrlStrategy();
  }

  // Enable semantics for automated testing / accessibility
  SemanticsBinding.instance.ensureSemantics();

  // ✅ Supabase seedha yahan initialize karo — runApp se pehle guaranteed
  try {
    await SupabaseService.initialize();
  } catch (e) {
    debugPrint('Supabase initialization failed: $e');
    // App fir bhi start hogi — screens apni error states handle karti hain
  }

  runApp(
    const ProviderScope(
      child: RideOnApp(),
    ),
  );
}
