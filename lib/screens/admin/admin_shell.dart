import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';

class AdminShell extends ConsumerWidget {
  final Widget child;
  const AdminShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 280,
            decoration: BoxDecoration(
              color: AppColors.primary,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(4, 0),
                ),
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 50),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.shield, size: 40, color: Colors.white),
                ),
                const SizedBox(height: 16),
                const Text(
                  'RideOn Controls',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const Text(
                  'ADMINISTRATOR',
                  style: TextStyle(color: Colors.white54, fontSize: 10, letterSpacing: 2),
                ),
                const SizedBox(height: 50),
                _buildSidebarItem(context, 'Dashboard', Icons.dashboard_rounded, '/admin'),
                _buildSidebarItem(context, 'User Management', Icons.people_alt_rounded, '/admin/users'),
                _buildSidebarItem(context, 'Verifications', Icons.verified_user_rounded, '/admin/documents'),
                _buildSidebarItem(context, 'SOS Monitoring', Icons.emergency_rounded, '/admin/sos'),
                _buildSidebarItem(context, 'Ride Logistics', Icons.route_rounded, '/admin/rides'),
                const Spacer(),
                const Divider(color: Colors.white12, indent: 20, endIndent: 20),
                _buildSidebarItem(context, 'Switch to Mobile App', Icons.phone_android_rounded, '/home'),
                ListTile(
                  onTap: () => _handleLogout(context, ref),
                  leading: const Icon(Icons.logout_rounded, color: Colors.white70),
                  title: const Text('Logout Session', style: TextStyle(color: Colors.white70)),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: Container(
              color: AppColors.background,
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(BuildContext context, String title, IconData icon, String route) {
    final String currentLocation = GoRouterState.of(context).matchedLocation;
    final bool isSelected = currentLocation == route;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white.withValues(alpha: 0.12) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: () => context.go(route),
        leading: Icon(icon, color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.64)),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.64),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _handleLogout(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to exit the Admin Panel?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('No')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Logout')),
        ],
      ),
    );

    if (confirm == true) {
      await ref.read(authActionsProvider).signOut();
      if (context.mounted) context.go('/welcome');
    }
  }
}
