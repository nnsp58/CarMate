import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/ride_provider.dart';
import '../../widgets/ride_manage_card.dart';
import '../../widgets/empty_state.dart';
import 'package:rideon/l10n/app_localizations.dart';

class MyRidesScreen extends ConsumerWidget {
  const MyRidesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ridesAsync = ref.watch(myPublishedRidesProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.my_published),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          bottom: TabBar(
            tabs: [
              Tab(text: AppLocalizations.of(context)!.active),
              Tab(text: AppLocalizations.of(context)!.past),
            ],
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
          ),
        ),
        body: ridesAsync.when(
          data: (rides) {
            final active = rides
                .where((r) => !r.isInPast && (r.status == 'active' || r.status == 'full'))
                .toList();
            final past = rides
                .where((r) => r.isInPast || r.status == 'completed' || r.status == 'cancelled' || r.status == 'ongoing')
                .toList();

            return TabBarView(
              children: [
                _buildRideList(active, 'No active rides', ref),
                _buildPastTab(past, ref),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }

  Widget _buildPastTab(List rides, WidgetRef ref) {
    return Column(
      children: [
        _buildSummaryCard(rides),
        const Divider(height: 1),
        Expanded(child: _buildRideList(rides, 'No past rides', ref)),
      ],
    );
  }

  Widget _buildSummaryCard(List rides) {
    int totalRides = rides.length;
    double totalEarnings = rides.fold(0.0, (sum, r) {
      // Assuming earnings are pricePerSeat * seatsBooked
      int booked = r.totalSeats - r.availableSeats;
      return sum + (r.pricePerSeat * booked);
    });
    int completedRides = rides.where((r) => r.status == 'completed').length;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      color: AppColors.primary.withValues(alpha: 0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Total Rides', totalRides.toString(), Icons.directions_car),
          _buildStatItem('Completed', completedRides.toString(), Icons.check_circle_outline),
          _buildStatItem('Total Earnings', '₹${totalEarnings.toStringAsFixed(0)}', Icons.account_balance_wallet_outlined),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
      ],
    );
  }

  Widget _buildRideList(List rides, String emptyMsg, WidgetRef ref) {
    if (rides.isEmpty) {
      return EmptyState(
        title: 'Empty',
        message: emptyMsg,
        icon: Icons.directions_car_filled_outlined,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: rides.length,
      itemBuilder: (context, index) {
        final ride = rides[index];
        return RideManageCard(
          ride: ride,
          onTap: () {
            context.push('/ride-passengers/${ride.id}');
          },
        );
      },
    );
  }
}
