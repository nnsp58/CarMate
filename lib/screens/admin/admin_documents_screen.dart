import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/admin_provider.dart';

class AdminDocumentsScreen extends ConsumerWidget {
  const AdminDocumentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingAsync = ref.watch(pendingVerificationsProvider);

    return DefaultTabController(
      length: 1, // Currently only implementing Pending as per flow
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Verification Requests', style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () => ref.invalidate(pendingVerificationsProvider),
              icon: const Icon(Icons.refresh),
            ),
            const SizedBox(width: 16),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(32),
          child: pendingAsync.when(
            data: (users) {
              if (users.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.verified_user_outlined, size: 64, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      const Text('No pending verifications!', style: TextStyle(color: Colors.grey, fontSize: 18)),
                    ],
                  ),
                );
              }

              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 32,
                  mainAxisSpacing: 32,
                  childAspectRatio: 0.85,
                ),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return _buildPendingCard(context, ref, users[index]);
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Center(child: Text('Error: $e')),
          ),
        ),
      ),
    );
  }

  Widget _buildPendingCard(BuildContext context, WidgetRef ref, Map<String, dynamic> user) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundImage: user['photo_url'] != null ? NetworkImage(user['photo_url']) : null,
                child: user['photo_url'] == null ? const Icon(Icons.person, size: 28) : null,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user['full_name'] ?? 'Unknown', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    Text(user['email'] ?? '', style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Text('Submitted Documents', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary)),
          const SizedBox(height: 16),
          Expanded(
            child: Row(
              children: [
                _buildDocThumbnail(context, 'DL Front', user['doc_driving_license_front']),
                const SizedBox(width: 16),
                _buildDocThumbnail(context, 'DL Back', user['doc_driving_license_back']),
                const SizedBox(width: 16),
                _buildDocThumbnail(context, 'Vehicle RC', user['doc_vehicle_rc']),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _handleRejection(context, ref, user['id']),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Reject Request', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _handleApproval(context, ref, user['id']),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: const Text('Approve User', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDocThumbnail(BuildContext context, String label, String? url) {
    return Expanded(
      child: InkWell(
        onTap: () {
          if (url != null) {
            showDialog(
              context: context,
              builder: (ctx) => Dialog(
                backgroundColor: Colors.transparent,
                child: Stack(
                  children: [
                    Image.network(url),
                    PositionButton(onPressed: () => Navigator.pop(ctx)),
                  ],
                ),
              ),
            );
          }
        },
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: url != null 
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(url, fit: BoxFit.cover),
                    )
                  : const Icon(Icons.no_photography_outlined, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  void _handleApproval(BuildContext context, WidgetRef ref, String userId) async {
    await ref.read(adminActionsProvider).verifyDocument(userId, true);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User verified successfully!')));
    }
  }

  void _handleRejection(BuildContext context, WidgetRef ref, String userId) async {
    final controller = TextEditingController();
    final reason = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reject Verification'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter rejection reason (e.g. Blurry photo)'),
          maxLines: 2,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, controller.text), child: const Text('Reject')),
        ],
      ),
    );

    if (reason != null && reason.isNotEmpty) {
      await ref.read(adminActionsProvider).verifyDocument(userId, false, reason: reason);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User rejected.')));
      }
    }
  }
}

class PositionButton extends StatelessWidget {
  final VoidCallback onPressed;
  const PositionButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      right: 10,
      child: IconButton(
        icon: const Icon(Icons.close, color: Colors.white, size: 30),
        onPressed: onPressed,
      ),
    );
  }
}
