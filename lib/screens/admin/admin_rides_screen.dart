import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/admin_provider.dart';
import '../../services/admin_service.dart';
import 'package:intl/intl.dart';

class AdminRidesScreen extends ConsumerWidget {
  const AdminRidesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ridesAsync = ref.watch(adminRidesProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Ride Management', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => ref.invalidate(adminRidesProvider),
            icon: const Icon(Icons.refresh),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 15)],
          ),
          child: ridesAsync.when(
            data: (rides) {
              if (rides.isEmpty) return const Center(child: Text('No rides found.'));

              return SingleChildScrollView(
                child: SizedBox(
                  width: double.infinity,
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(AppColors.primary.withValues(alpha: 0.05)),
                    columns: const [
                      DataColumn(label: Text('DRIVER', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('ROUTE', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('DEPARTURE', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('SEATS', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('STATUS', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('ACTIONS', style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                    rows: rides.map((ride) {
                      final departure = DateTime.parse(ride['departure_datetime']);
                      final status = (ride['status'] ?? 'active').toString();
                      
                      return DataRow(cells: [
                        DataCell(Text(ride['driver_name'] ?? 'Unknown')),
                        DataCell(Text('${ride['from_location']} → ${ride['to_location']}', style: const TextStyle(fontSize: 13))),
                        DataCell(Text(DateFormat('MMM dd, HH:mm').format(departure))),
                        DataCell(Text('${ride['available_seats']}/${ride['total_seats']}')),
                        DataCell(Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getStatusColor(status).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            status.toUpperCase(),
                            style: TextStyle(color: _getStatusColor(status), fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        )),
                        DataCell(
                          IconButton(
                            icon: const Icon(Icons.cancel_outlined, color: Colors.grey),
                            onPressed: status == 'active' ? () => _forceCancel(context, ref, ride['id']) : null,
                          ),
                        ),
                      ]);
                    }).toList(),
                  ),
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Center(child: Text('Error: $e')),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active': return Colors.green;
      case 'full': return Colors.blue;
      case 'completed': return Colors.grey;
      case 'cancelled': return Colors.red;
      default: return Colors.orange;
    }
  }

  void _forceCancel(BuildContext context, WidgetRef ref, String rideId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Force Cancel Ride?'),
        content: const Text('This will cancel the ride and notify passengers. Are you sure?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('No')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Yes, Cancel')),
        ],
      ),
    );

    if (confirm == true) {
      await AdminService.forceCancelRide(rideId);
      ref.invalidate(adminRidesProvider);
    }
  }
}
