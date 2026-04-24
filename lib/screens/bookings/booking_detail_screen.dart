import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/booking_provider.dart';
import '../../models/booking_model.dart';
import '../../widgets/empty_state.dart';
import '../../providers/auth_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:rideon/l10n/app_localizations.dart';
import '../../services/review_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../services/map_service.dart';
import '../../providers/ride_provider.dart';
import '../../core/utils/cached_tile_provider.dart';

class BookingDetailScreen extends ConsumerStatefulWidget {
  final String bookingId;
  const BookingDetailScreen({super.key, required this.bookingId});

  @override
  ConsumerState<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends ConsumerState<BookingDetailScreen> {
  List<LatLng> _routePoints = [];
  bool _isLoadingRoute = false;
  final MapController _mapController = MapController();

  Future<void> _fetchRoute(BookingModel booking) async {
    if (_routePoints.isNotEmpty || _isLoadingRoute) return;
    if (booking.fromLat == null || booking.toLat == null) return;

    setState(() => _isLoadingRoute = true);
    try {
      final start = LatLng(booking.fromLat!, booking.fromLng!);
      final end = LatLng(booking.toLat!, booking.toLng!);
      final route = await MapService.getRoute(start, end);
      
      if (mounted) {
        setState(() {
          _routePoints = route;
          _isLoadingRoute = false;
        });
        _fitBounds();
      }
    } catch (e) {
      debugPrint('Error fetching booking route: $e');
    } finally {
      if (mounted) setState(() => _isLoadingRoute = false);
    }
  }

  void _fitBounds() {
    if (_routePoints.isEmpty) return;
    
    var swLat = _routePoints.first.latitude;
    var swLng = _routePoints.first.longitude;
    var neLat = _routePoints.first.latitude;
    var neLng = _routePoints.first.longitude;
    
    for (var point in _routePoints) {
      if (point.latitude < swLat) swLat = point.latitude;
      if (point.longitude < swLng) swLng = point.longitude;
      if (point.latitude > neLat) neLat = point.latitude;
      if (point.longitude > neLng) neLng = point.longitude;
    }
    
    final bounds = LatLngBounds(LatLng(swLat, swLng), LatLng(neLat, neLng));
    _mapController.fitCamera(
      CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(50)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookingAsync = ref.watch(bookingDetailsProvider(widget.bookingId));
    final dateFormat = DateFormat('EEEE, d MMMM y • hh:mm a');
    final user = ref.watch(currentUserProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.booking_details),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              final booking = ref.read(bookingDetailsProvider(widget.bookingId)).value;
              if (booking != null) {
                _shareRide(booking);
              }
            },
          ),
        ],
      ),
      body: bookingAsync.when(
        data: (booking) {
          if (booking == null) {
            return const EmptyState(
              title: 'Booking not found',
              message: 'The requested booking could not be retrieved.',
              icon: Icons.error_outline,
            );
          }

          final isPast = booking.departureDatetime != null && booking.departureDatetime!.isBefore(DateTime.now());
          final isDriver = user?.id == booking.driverId;

          if (booking.fromLat != null && booking.toLat != null && _routePoints.isEmpty) {
             WidgetsBinding.instance.addPostFrameCallback((_) => _fetchRoute(booking));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status Header
                _buildStatusBanner(booking.status),
                const SizedBox(height: 24),

                // Map Segment (If coordinates exist)
                if (booking.fromLat != null && booking.toLat != null) ...[
                  const Text(
                    'Passenger Route Segment',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 200,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Stack(
                      children: [
                        FlutterMap(
                          mapController: _mapController,
                          options: MapOptions(
                            initialCenter: LatLng(booking.fromLat!, booking.fromLng!),
                            initialZoom: 10,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.rideon.app',
                              tileProvider: CachedTileProvider(),
                            ),
                            if (_routePoints.isNotEmpty)
                              PolylineLayer(
                                polylines: [
                                  Polyline(
                                    points: _routePoints,
                                    color: AppColors.primary,
                                    strokeWidth: 4,
                                  ),
                                ],
                              ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: LatLng(booking.fromLat!, booking.fromLng!),
                                  width: 40,
                                  height: 40,
                                  child: const Icon(Icons.location_on, color: AppColors.primary, size: 30),
                                ),
                                Marker(
                                  point: LatLng(booking.toLat!, booking.toLng!),
                                  width: 40,
                                  height: 40,
                                  child: const Icon(Icons.location_on, color: AppColors.secondary, size: 30),
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (_isLoadingRoute)
                          const Center(child: CircularProgressIndicator()),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Ride Info Section
                const Text(
                  'Ride Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildRouteSection(booking),
                const SizedBox(height: 24),

                _buildInfoRow(
                  icon: Icons.calendar_today,
                  label: 'Departure Time',
                  value: booking.departureDatetime != null 
                    ? dateFormat.format(booking.departureDatetime!)
                    : 'Not available',
                  isWarning: isPast && booking.status == 'confirmed',
                ),
                const SizedBox(height: 32),

                if (isDriver) ...[
                  const Text(
                    'Passenger Information',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildPassengerDetails(booking),
                  const SizedBox(height: 32),
                ],

                // Booking Details Section
                const Text(
                  'Booking Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildInfoRow(
                  icon: Icons.airline_seat_recline_normal,
                  label: 'Seats Reserved',
                  value: '${booking.seatsBooked} seat${booking.seatsBooked > 1 ? 's' : ''}',
                ),
                const SizedBox(height: 16),
                _buildInfoRow(
                  icon: Icons.payments_outlined,
                  label: 'Total Amount Paid',
                  value: '₹${booking.totalPrice.toStringAsFixed(0)}',
                ),
                const SizedBox(height: 16),
                _buildInfoRow(
                  icon: Icons.access_time,
                  label: 'Booked On',
                  value: dateFormat.format(booking.bookedAt),
                ),
                
                const SizedBox(height: 40),

                // Driver Actions: Reject booking
                if (isDriver && booking.status == 'confirmed' && !isPast) ...[
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _showDriverRejectDialog(context, ref, booking),
                          icon: const Icon(Icons.cancel_outlined),
                          label: const Text('Reject Booking'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[50],
                            foregroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],

                // Passenger Action: Cancel booking
                if (!isDriver && booking.status == 'confirmed' && !isPast)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _showCancelDialog(context, ref, booking),
                      icon: const Icon(Icons.cancel_outlined),
                      label: Text(AppLocalizations.of(context)!.cancel_booking),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[50],
                        foregroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),

                if (booking.status == 'completed' || (isPast && booking.status == 'confirmed'))
                   SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _showRatingDialog(context, ref, booking),
                      icon: const Icon(Icons.star_outline),
                      label: Text(AppLocalizations.of(context)!.rate_trip),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryLight.withValues(alpha: 0.5),
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: bookingAsync.maybeWhen(
        data: (booking) {
          if (booking == null || booking.status == 'cancelled') return null;
          return FloatingActionButton.extended(
            onPressed: () => _handleChat(ref, booking),
            label: const Text('Chat with Driver'),
            icon: const Icon(Icons.chat_bubble_outline),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          );
        },
        orElse: () => null,
      ),
    );
  }

  Future<void> _handleChat(WidgetRef ref, BookingModel booking) async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) return;

    try {
      final chatId = await ref.read(chatActionsProvider).getOrCreateChat(
            otherUserId: user.id == booking.passengerId ? booking.driverId : booking.passengerId,
            rideId: booking.rideId,
            bookingId: booking.id,
          );
      if (mounted) {
        context.push('/chat/$chatId');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not start chat: $e')),
        );
      }
    }
  }

  Widget _buildStatusBanner(String status) {
    Color color;
    IconData icon;
    String label = status.toUpperCase();

    switch (status.toLowerCase()) {
      case 'confirmed':
        color = AppColors.success;
        icon = Icons.check_circle_outline;
        break;
      case 'cancelled':
        color = AppColors.error;
        icon = Icons.cancel_outlined;
        break;
      case 'completed':
        color = AppColors.primary;
        icon = Icons.done_all;
        break;
      default:
        color = Colors.grey;
        icon = Icons.help_outline;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const Text('Booking Status', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRouteSection(BookingModel booking) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Column(
            children: [
              const Icon(Icons.circle_outlined, size: 20, color: AppColors.primary),
              Container(width: 1, height: 30, color: Colors.grey[300]),
              const Icon(Icons.location_on, size: 20, color: AppColors.secondary),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.displayFrom,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 24),
                Text(
                  booking.displayTo,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPassengerDetails(BookingModel booking) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: (booking.passengerPhotoUrl != null && booking.passengerPhotoUrl!.isNotEmpty) 
                  ? NetworkImage(booking.passengerPhotoUrl!) 
                  : null,
                child: (booking.passengerPhotoUrl == null || booking.passengerPhotoUrl!.isEmpty) 
                  ? const Icon(Icons.person) 
                  : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(booking.passengerName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    if (booking.passengerBio != null)
                      Text(booking.passengerBio!, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              Row(
                children: [
                  if (booking.passengerPhone != null)
                    IconButton(
                      icon: const Icon(Icons.phone, color: AppColors.primary),
                      onPressed: () => _launchCaller(booking.passengerPhone!),
                    ),
                  if (booking.passengerEmail != null)
                    IconButton(
                      icon: const Icon(Icons.email, color: AppColors.primary),
                      onPressed: () => _launchEmail(booking.passengerEmail!),
                    ),
                ],
              ),
            ],
          ),
          if (booking.passengerPhone != null || booking.passengerEmail != null) ...[
            const Divider(height: 24),
            if (booking.passengerPhone != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    const Icon(Icons.call, size: 16, color: Colors.grey),
                    const SizedBox(width: 12),
                    Text(booking.passengerPhone!, style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            if (booking.passengerEmail != null)
              Row(
                children: [
                  const Icon(Icons.alternate_email, size: 16, color: Colors.grey),
                  const SizedBox(width: 12),
                  Text(booking.passengerEmail!, style: const TextStyle(fontSize: 14)),
                ],
              ),
          ],
        ],
      ),
    );
  }

  void _launchCaller(String phone) async {
    final Uri url = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  void _launchEmail(String email) async {
    final Uri url = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    bool isWarning = false,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isWarning ? Colors.red[50] : AppColors.primaryLight.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: isWarning ? Colors.red : AppColors.primary, size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15, 
                  fontWeight: FontWeight.w600,
                  color: isWarning ? Colors.red : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _shareRide(BookingModel booking) {
    final text = 'Hey! I am travelling from ${booking.displayFrom} to ${booking.displayTo} using RideOn. Join me or find your own ride! \n\nGet the app on Play Store.';
    Share.share(text, subject: 'RideOn Trip Details');
  }

  void _showCancelDialog(BuildContext context, WidgetRef ref, BookingModel booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking?'),
        content: const Text('Are you sure you want to cancel this booking? This action cannot be undone and seats will be released.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('No, keep it')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final user = ref.read(currentUserProvider).value;
              if (user == null) return;
              try {
                await ref.read(bookRideProvider.notifier).cancel(
                  bookingId: booking.id,
                  userId: user.id,
                  reason: 'Cancelled by passenger',
                );
                ref.invalidate(bookingDetailsProvider(widget.bookingId));
                ref.invalidate(myBookingsProvider);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Booking cancelled successfully')));
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Yes, cancel'),
          ),
        ],
      ),
    );
  }

  void _showDriverRejectDialog(BuildContext context, WidgetRef ref, BookingModel booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Booking?'),
        content: const Text('Are you sure you want to reject this booking? The passenger will be notified and seats will be available again.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('No')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final user = ref.read(currentUserProvider).value;
              if (user == null) return;
              try {
                await ref.read(bookRideProvider.notifier).cancel(
                  bookingId: booking.id,
                  userId: user.id,
                  reason: 'Rejected by driver',
                );
                ref.invalidate(bookingDetailsProvider(widget.bookingId));
                ref.invalidate(rideBookingsProvider(booking.rideId));
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Booking rejected')));
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Yes, Reject'),
          ),
        ],
      ),
    );
  }

  void _showRatingDialog(BuildContext context, WidgetRef ref, BookingModel booking) {
    int localRating = 5;
    final commentController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('How was your trip?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) => IconButton(
                  icon: Icon(index < localRating ? Icons.star : Icons.star_border, color: Colors.amber, size: 32),
                  onPressed: () => setState(() => localRating = index + 1),
                )),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: commentController,
                decoration: InputDecoration(hintText: 'Add a comment (Optional)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('SKIP')),
            ElevatedButton(
              onPressed: () async {
                final user = ref.read(currentUserProvider).value;
                if (user == null) return;
                await ReviewService.submitReview(
                  rideId: booking.rideId,
                  bookingId: booking.id,
                  revieweeId: user.id == booking.passengerId ? booking.driverId : booking.passengerId,
                  rating: localRating.toInt(),
                  comment: commentController.text,
                );
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('SUBMIT'),
            ),
          ],
        ),
      ),
    );
  }
}
