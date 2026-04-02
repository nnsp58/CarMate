import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/booking_provider.dart';
import '../../widgets/booking_card.dart';
import '../../widgets/empty_state.dart';
import 'package:rideon/l10n/app_localizations.dart';

class MyBookingsScreen extends ConsumerWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingsAsync = ref.watch(myBookingsProvider);

    return DefaultTabController(
      length: 2, // Changed back to 2 as we don't have ride departure date in booking model yet
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.my_bookings),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => ref.invalidate(myBookingsProvider),
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: AppLocalizations.of(context)!.active),
              Tab(text: AppLocalizations.of(context)!.past),
            ],
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
        body: bookingsAsync.when(
          data: (bookings) {
            // Active: Confirmed or Pending bookings that are NOT in the past
            final active = bookings
                .where((b) => !b.isInPast && (b.status == 'confirmed' || b.status == 'pending'))
                .toList();

            // Past: Completed, Cancelled, or any booking where the ride time has passed
            final past = bookings
                .where((b) => b.isInPast || b.status == 'cancelled' || b.status == 'completed')
                .toList();

            return TabBarView(
              children: [
                _buildBookingList(context, active, 'No active bookings'),
                _buildBookingList(context, past, 'No past bookings'),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }

  Widget _buildBookingList(BuildContext context, List bookings, String emptyMsg) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            EmptyState(
              title: 'No Bookings',
              message: emptyMsg,
              icon: Icons.bookmark_border,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('Find a Ride'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return BookingCard(
          booking: booking,
          onTap: () {
             context.push('/booking-detail/${booking.id}');
          },
        );
      },
    );
  }
}
