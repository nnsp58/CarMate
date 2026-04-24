import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/booking_provider.dart';
import '../../providers/chat_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/ride_provider.dart';
import '../../services/ride_service.dart';
import '../../widgets/empty_state.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rideon/l10n/app_localizations.dart';

class RidePassengersScreen extends ConsumerWidget {
  final String rideId;
  const RidePassengersScreen({super.key, required this.rideId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingsAsync = ref.watch(rideBookingsProvider(rideId));
    final rideAsync = ref.watch(rideDetailsProvider(rideId));
    final user = ref.watch(currentUserProvider).value;
    final currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Ride'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: rideAsync.when(
        data: (ride) {
          if (ride == null) return const Center(child: Text('Ride not found'));

          return Column(
            children: [
              // Ride Details Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: AppColors.primary.withValues(alpha: 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.circle_outlined, size: 16, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Expanded(child: Text(ride.fromLocation, style: const TextStyle(fontWeight: FontWeight.bold))),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 7),
                      child: Icon(Icons.more_vert, size: 14, color: Colors.grey),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.place, size: 16, color: AppColors.secondary),
                        const SizedBox(width: 8),
                        Expanded(child: Text(ride.toLocation, style: const TextStyle(fontWeight: FontWeight.bold))),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            DateFormat('EEEE, MMM d • hh:mm a').format(ride.departureDatetime),
                            style: TextStyle(color: Colors.grey[700]),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getStatusColor(ride.status).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            ride.status.toUpperCase(),
                            style: TextStyle(color: _getStatusColor(ride.status), fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    if (ride.status == 'active' || ride.status == 'full') ...[
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => context.push('/publish', extra: ride),
                              icon: const Icon(Icons.edit_outlined),
                              label: Text(AppLocalizations.of(context)!.edit_ride),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _handleStartRide(context, ref, ride, user?.id),
                              icon: const Icon(Icons.play_arrow),
                              label: const Text('Start Ride'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => _confirmCancelRide(context, ref, ride, user?.id),
                          icon: const Icon(Icons.cancel_outlined, color: Colors.red),
                          label: Text(
                            AppLocalizations.of(context)!.cancel_ride,
                            style: const TextStyle(color: Colors.red),
                          ),
                          style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red)),
                        ),
                      ),
                    ] else if (ride.status == 'completed' || ride.status == 'cancelled' || ride.isInPast) ...[
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => context.push('/publish', extra: ride),
                          icon: const Icon(Icons.copy),
                          label: const Text('Duplicate Ride'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                    if (ride.status == 'ongoing') ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.blue),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Ride is currently ongoing. It will be marked as completed automatically after the estimated duration.',
                                style: TextStyle(color: Colors.blue, fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Divider(height: 1),
              const Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.people, color: AppColors.primary, size: 20),
                    SizedBox(width: 8),
                    Text('PASSENGERS', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary, letterSpacing: 1)),
                  ],
                ),
              ),
              Expanded(
                child: bookingsAsync.when(
                  data: (bookings) {
                    if (bookings.isEmpty) {
                      return const EmptyState(
                        title: 'No bookings yet',
                        message: 'When someone books a seat, they will appear here.',
                        icon: Icons.people_outline,
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: bookings.length,
                      itemBuilder: (context, index) {
                        final booking = bookings[index];
                        return _buildPassengerCard(context, ref, booking, currencyFormat);
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => const Center(child: Text('Error loading passengers')),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => const Center(child: Text('Error loading ride details')),
      ),
    );
  }

  Widget _buildPassengerCard(BuildContext context, WidgetRef ref, dynamic booking, NumberFormat currencyFormat) {
    final isCancelled = booking.status == 'cancelled';
    return InkWell(
      onTap: () => context.push('/booking-detail/${booking.id}'),
      borderRadius: BorderRadius.circular(16),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: AppColors.primaryLight,
                    child: Icon(Icons.person, color: AppColors.primary),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(booking.passengerName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(
                          '${booking.seatsBooked} ${booking.seatsBooked > 1 ? 'seats' : 'seat'} • ${currencyFormat.format(booking.totalPrice)}',
                          style: const TextStyle(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusChip(booking.status),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${booking.displayFrom} → ${booking.displayTo}',
                      style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              if (!isCancelled) ...[
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () => _confirmCancelBooking(context, ref, booking),
                      icon: const Icon(Icons.cancel_outlined, size: 20),
                      label: const Text('Cancel'),
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: () => _handleChat(context, ref, booking),
                      icon: const Icon(Icons.chat_bubble_outline, size: 20),
                      label: const Text('Message'),
                      style: TextButton.styleFrom(foregroundColor: AppColors.primary),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _confirmCancelBooking(BuildContext context, WidgetRef ref, dynamic booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking?'),
        content: const Text('Are you sure you want to remove this passenger?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('NO')),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                final user = ref.read(currentUserProvider).value;
                if (user == null) return;
                
                await ref.read(bookRideProvider.notifier).cancel(
                  bookingId: booking.id,
                  userId: user.id,
                  reason: 'Cancelled by driver',
                );
                
                ref.invalidate(rideBookingsProvider(booking.rideId));
                ref.invalidate(rideDetailsProvider(booking.rideId));
                ref.invalidate(myPublishedRidesProvider);
                
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Booking Cancelled')));
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              }
            },
            child: const Text('YES, CANCEL', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'ongoing': return Colors.blue;
      case 'completed': return AppColors.primary;
      default: return Colors.grey;
    }
  }

  void _handleStartRide(BuildContext context, WidgetRef ref, dynamic ride, String? driverId) async {
    if (driverId == null) return;

    // GPS Check (Optional but smart)
    bool isNear = false;
    try {
      final position = await Geolocator.getCurrentPosition();
      if (ride.fromLat != null && ride.fromLng != null) {
        final distance = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          ride.fromLat!,
          ride.fromLng!,
        );
        if (distance < 1000) isNear = true; // Within 1km
      }
    } catch (_) {}

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start Ride?'),
        content: Text(
          isNear 
            ? 'You are near the start point. Do you want to start the ride now?'
            : 'Are you sure you want to start the ride? This will mark it as ongoing and hide it from search.'
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('NO')),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await RideService.startRide(rideId: ride.id, driverId: driverId);
                ref.invalidate(myPublishedRidesProvider);
                ref.invalidate(rideDetailsProvider(ride.id));
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ride started! Passengers have been notified.')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              }
            },
            child: const Text('YES, START', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _confirmCancelRide(BuildContext context, WidgetRef ref, dynamic ride, String? driverId) {
    if (driverId == null) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Ride?'),
        content: const Text('Are you sure you want to cancel this ride? This action cannot be undone and will notify all passengers.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('NO')),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await RideService.cancelRide(rideId: ride.id, driverId: driverId);
                ref.invalidate(myPublishedRidesProvider);
                ref.invalidate(rideDetailsProvider(ride.id));
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ride cancelled successfully')));
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              }
            },
            child: const Text('YES, CANCEL', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'confirmed':
        color = Colors.green;
        break;
      case 'pending':
        color = Colors.orange;
        break;
      case 'cancelled':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<void> _handleChat(BuildContext context, WidgetRef ref, dynamic booking) async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) return;

    try {
      final chatId = await ref.read(chatActionsProvider).getOrCreateChat(
            otherUserId: booking.passengerId,
            rideId: booking.rideId,
            bookingId: booking.id,
          );
      if (context.mounted) {
        context.push('/chat/$chatId');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not start chat: $e')),
        );
      }
    }
  }
}
