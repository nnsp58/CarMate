import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/ride_model.dart';
import '../../services/supabase_service.dart';
import '../../screens/splash/splash_screen.dart';
import '../../screens/auth/welcome_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/signup_screen.dart';
import '../../screens/auth/otp_screen.dart';
import '../../screens/onboarding/profile_setup_screen.dart';
import '../../screens/onboarding/vehicle_setup_screen.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/search/search_rides_screen.dart';
import '../../screens/search/ride_details_screen.dart';
import '../../screens/publish/publish_ride_screen.dart';
import '../../screens/bookings/my_bookings_screen.dart';
import '../../screens/bookings/booking_detail_screen.dart';
import '../../screens/rides/my_rides_screen.dart';
import '../../screens/rides/ride_passengers_screen.dart';
import '../../screens/chat/chat_screen.dart';
import '../../screens/profile/profile_screen.dart';
import '../../screens/profile/edit_profile_screen.dart';
import '../../screens/profile/documents_screen.dart';
import '../../screens/profile/reports_screen.dart';
import '../../screens/notifications/notifications_screen.dart';
import '../../screens/main_screen.dart';
import '../../screens/admin/admin_shell.dart';
import '../../screens/admin/admin_dashboard_screen.dart';
import '../../screens/admin/admin_users_screen.dart';
import '../../screens/admin/admin_documents_screen.dart';
import '../../screens/admin/admin_sos_screen.dart';
import '../../screens/admin/admin_rides_screen.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _adminNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    redirect: (context, state) async {
      // Admin route guard — only check for /admin paths
      final path = state.matchedLocation;
      if (path.startsWith('/admin')) {
        final userId = SupabaseService.currentUserId;
        if (userId == null) return '/welcome';

        try {
          final response = await SupabaseService.client
              .from('users')
              .select('is_admin')
              .eq('id', userId)
              .maybeSingle();

          final isAdmin = response?['is_admin'] == true;
          if (!isAdmin) return '/home';
        } catch (_) {
          return '/home';
        }
      }
      return null; // No redirect needed
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),

      // Auth routes
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/otp',
        builder: (context, state) {
          final phone = state.extra as String? ?? '';
          return OTPScreen(phoneNumber: phone);
        },
      ),

      // Onboarding routes
      GoRoute(
        path: '/profile-setup',
        builder: (context, state) => const ProfileSetupScreen(),
      ),
      GoRoute(
        path: '/vehicle-setup',
        builder: (context, state) => const VehicleSetupScreen(),
      ),

      // Main App Shell
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainScreen(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/my-bookings',
            builder: (context, state) => const MyBookingsScreen(),
          ),
          GoRoute(
            path: '/my-rides',
            builder: (context, state) => const MyRidesScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),

      // Independent Screens (without bottom nav)
      GoRoute(
        path: '/search',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SearchRidesScreen(),
      ),
      GoRoute(
        path: '/ride-details/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final from = state.uri.queryParameters['from'];
          final to = state.uri.queryParameters['to'];
          final fromLat = double.tryParse(state.uri.queryParameters['fromLat'] ?? '');
          final fromLng = double.tryParse(state.uri.queryParameters['fromLng'] ?? '');
          final toLat = double.tryParse(state.uri.queryParameters['toLat'] ?? '');
          final toLng = double.tryParse(state.uri.queryParameters['toLng'] ?? '');

          return RideDetailsScreen(
            rideId: state.pathParameters['id']!,
            searchFrom: from,
            searchTo: to,
            searchFromLat: fromLat,
            searchFromLng: fromLng,
            searchToLat: toLat,
            searchToLng: toLng,
          );
        },
      ),
      GoRoute(
        path: '/publish',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final ride = state.extra as RideModel?;
          return PublishRideScreen(ride: ride);
        },
      ),

      GoRoute(
        path: '/booking-detail/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => BookingDetailScreen(
          bookingId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/ride-passengers/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => RidePassengersScreen(
          rideId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/chat/:chatId',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final chatId = state.pathParameters['chatId']!;
          final extra = state.extra as Map<String, dynamic>?;
          final otherUserName = extra?['otherUserName'] as String? ?? 'Chat';
          return ChatScreen(chatId: chatId, otherUserName: otherUserName);
        },
      ),
      GoRoute(
        path: '/edit-profile',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/documents',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const DocumentsScreen(),
      ),
      GoRoute(
        path: '/notifications',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/reports',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ReportsScreen(),
      ),

      // Admin Panel (Web Explorer Interface) — GUARDED via GoRouter redirect
      ShellRoute(
        navigatorKey: _adminNavigatorKey,
        builder: (context, state, child) => AdminShell(child: child),
        routes: [
          GoRoute(
            path: '/admin',
            builder: (context, state) => const AdminDashboardScreen(),
          ),
          GoRoute(
            path: '/admin/users',
            builder: (context, state) => const AdminUsersScreen(),
          ),
          GoRoute(
            path: '/admin/documents',
            builder: (context, state) => const AdminDocumentsScreen(),
          ),
          GoRoute(
            path: '/admin/sos',
            builder: (context, state) => const AdminSOSScreen(),
          ),
          GoRoute(
            path: '/admin/rides',
            builder: (context, state) => const AdminRidesScreen(),
          ),
        ],
      ),
    ],
  );
}
