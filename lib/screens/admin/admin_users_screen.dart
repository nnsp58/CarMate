import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/admin_provider.dart';
import 'package:intl/intl.dart';

class AdminUsersScreen extends ConsumerStatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  ConsumerState<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends ConsumerState<AdminUsersScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(adminUsersProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('User Management', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => ref.invalidate(adminUsersProvider),
            icon: const Icon(Icons.refresh),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            // Search Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
              ),
              child: TextField(
                onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
                decoration: const InputDecoration(
                  hintText: 'Search users by name, email or phone...',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 32),
            // User Table
            Expanded(
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 15)],
                ),
                child: usersAsync.when(
                  data: (users) {
                    final filteredUsers = users.where((u) {
                      final name = (u['full_name'] ?? '').toString().toLowerCase();
                      final email = (u['email'] ?? '').toString().toLowerCase();
                      final phone = (u['phone'] ?? '').toString();
                      return name.contains(_searchQuery) || email.contains(_searchQuery) || phone.contains(_searchQuery);
                    }).toList();

                    if (filteredUsers.isEmpty) {
                      return const Center(child: Text('No users found.'));
                    }

                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SizedBox(
                        width: double.infinity,
                        child: DataTable(
                          headingRowColor: WidgetStateProperty.all(AppColors.primary.withValues(alpha: 0.05)),
                          columns: const [
                            DataColumn(label: Text('USER INFO', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('CONTACT', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('STATUS', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('JOINED DATE', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('ACTIONS', style: TextStyle(fontWeight: FontWeight.bold))),
                          ],
                          rows: filteredUsers.map((user) {
                            final bool isBanned = user['is_banned'] ?? false;
                            final bool isAdmin = user['is_admin'] ?? false;
                            final createdAt = DateTime.parse(user['created_at']);

                            return DataRow(cells: [
                              DataCell(Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: user['photo_url'] != null ? NetworkImage(user['photo_url']) : null,
                                    child: user['photo_url'] == null ? const Icon(Icons.person) : null,
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(user['full_name'] ?? 'No Name', style: const TextStyle(fontWeight: FontWeight.bold)),
                                      if (isAdmin) Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(color: Colors.indigo[50], borderRadius: BorderRadius.circular(4)),
                                        child: const Text('ADMIN', style: TextStyle(fontSize: 10, color: Colors.indigo, fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                              DataCell(Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(user['email'] ?? 'No Email', style: const TextStyle(fontSize: 13)),
                                  Text(user['phone'] ?? 'No Phone', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                ],
                              )),
                              DataCell(Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isBanned ? Colors.red[50] : Colors.green[50],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  isBanned ? 'Banned' : 'Active',
                                  style: TextStyle(color: isBanned ? Colors.red : Colors.green, fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              )),
                              DataCell(Text(DateFormat('MMM dd, yyyy').format(createdAt))),
                              DataCell(Row(
                                children: [
                                  IconButton(
                                    icon: Icon(isBanned ? Icons.check_circle_outline : Icons.block, color: isBanned ? Colors.green : Colors.red, size: 20),
                                    tooltip: isBanned ? 'Unban User' : 'Ban User',
                                    onPressed: () => _toggleBan(user['id'], isBanned),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.info_outline, color: Colors.blue, size: 20),
                                    tooltip: 'View Details',
                                    onPressed: () {},
                                  ),
                                ],
                              )),
                            ]);
                          }).toList(),
                        ),
                      ),
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, s) => Center(child: Text('Error loading users: $e')),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleBan(String userId, bool currentStatus) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(currentStatus ? 'Unban User?' : 'Ban User?'),
        content: Text('Are you sure you want to ${currentStatus ? "unban" : "ban"} this user?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: currentStatus ? Colors.green : Colors.red),
            child: Text(currentStatus ? 'Unban' : 'Ban'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ref.read(adminActionsProvider).updateUserStatus(userId, !currentStatus);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User status updated!')));
      }
    }
  }
}
