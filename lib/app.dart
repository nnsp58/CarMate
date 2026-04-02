import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rideon/l10n/app_localizations.dart';
import 'providers/locale_provider.dart';

// ✅ FIX: Supabase initialize ab main.dart mein hota hai.
// Builder() se remove kar diya — wahan sirf UI builder logic honi chahiye.
// ✅ FIX: darkTheme add kiya — raat ko app use karne wale users ke liye.
class RideOnApp extends ConsumerWidget {
  const RideOnApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'RideOn',
      locale: locale,

      // Light theme
      theme: AppTheme.lightTheme,

      // ✅ Dark theme ab support karta hai
      darkTheme: AppTheme.darkTheme,

      // System ke according light/dark automatically switch hoga
      themeMode: ThemeMode.system,

      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English (default)
        Locale('hi'), // Hindi
      ],
      // ✅ builder() ab sirf child return karta hai — Supabase init yahaan se hata diya
      builder: (context, child) => child ?? const SizedBox.shrink(),
    );
  }
}
