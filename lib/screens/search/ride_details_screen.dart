import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../core/utils/cached_tile_provider.dart';
import '../../core/constants/app_colors.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../services/map_service.dart';
import '../../providers/ride_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';
import '../../providers/notification_provider.dart';
import '../../providers/chat_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:rideon/l10n/app_localizations.dart';
import 'package:rideon/models/ride_model.dart';
import '../../services/ride_service.dart';

class RideDetailsScreen extends ConsumerStatefulWidget {
  final String rideId;
  final String? searchFrom;
  final String? searchTo;
  final double? searchFromLat;
  final double? searchFromLng;
  final double? searchToLat;
  final double? searchToLng;

  const RideDetailsScreen({
    super.key, 
    required this.rideId,
    this.searchFrom,
    this.searchTo,
    this.searchFromLat,
    this.searchFromLng,
    this.searchToLat,
    this.searchToLng,
  });

  @override
  ConsumerState<RideDetailsScreen> createState() => _RideDetailsScreenState();
}

class _RideDetailsScreenState extends ConsumerState<RideDetailsScreen> {
  int _seatsToBook = 1;
  bool _isBooking = false;
  List<LatLng> _routePoints = [];
  bool _isLoadingRoute = false;
  LatLng? _startCoord;
  LatLng? _endCoord;
  final MapController _mapController = MapController();
  RideModel? _calculatedRide; // Stores segment-calculated ride with pro-rata price

  @override
  void initState() {
    super.initState();
  }

  Future<void> _fetchRoute(RideModel ride) async {
    if (_routePoints.isNotEmpty || _isLoadingRoute) return;

    setState(() => _isLoadingRoute = true);

    try {
      // 1. Try to use stored route points
      if (ride.routePointsJson != null && ride.routePointsJson!.isNotEmpty) {
        final points = ride.routePointsJson!
            .map((p) => LatLng((p['lat'] as num).toDouble(), (p['lng'] as num).toDouble()))
            .toList();
        if (mounted) {
          setState(() {
            _routePoints = points;
            _startCoord = points.first;
            _endCoord = points.last;
            _isLoadingRoute = false;
          });
          _fitBounds();
        }
        return;
      }

      // 2. Fallback: Geocode locations and fetch route from API
      final startRes = await MapService.searchPlaces(ride.fromLocation);
      final endRes = await MapService.searchPlaces(ride.toLocation);

      if (startRes.isNotEmpty && endRes.isNotEmpty) {
        _startCoord = LatLng(startRes[0]['lat'], startRes[0]['lon']);
        _endCoord = LatLng(endRes[0]['lat'], endRes[0]['lon']);

        final route = await MapService.getRoute(_startCoord!, _endCoord!);
        if (mounted) {
          setState(() {
            _routePoints = route;
            _isLoadingRoute = false;
          });
          
          // Fit bounds after route is loaded
          if (_routePoints.isNotEmpty) {
            _fitBounds();
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading route: $e');
    } finally {
      if (mounted) setState(() => _isLoadingRoute = false);
    }
  }

  void _fitBounds() {
    if (_routePoints.isEmpty) return;
    
    // Calculate bounds
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
      CameraFit.bounds(
        bounds: bounds,
        padding: const EdgeInsets.all(50),
      ),
    );
  }


  Future<void> _handleBooking(WidgetRef ref) async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) {
      context.go('/login');
      return;
    }

    // Use the segment-calculated ride (with pro-rata price), not the raw DB ride
    var ride = _calculatedRide ?? ref.read(rideDetailsProvider(widget.rideId)).value;
    if (ride == null) return;

    // Double check segment price in handleBooking as well
    if (widget.searchFromLat != null && widget.searchToLat != null) {
      final segmentRide = RideService.calculateRideSegment(
        ride: ride,
        searchFromLat: widget.searchFromLat!,
        searchFromLng: widget.searchFromLng!,
        searchToLat: widget.searchToLat!,
        searchToLng: widget.searchToLng!,
      );
      if (segmentRide != null) {
        ride = segmentRide;
      }
    }

    if (ride.driverId == user.id) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You cannot book your own ride')),
      );
      return;
    }

    setState(() => _isBooking = true);

    try {
      await ref.read(bookRideProvider.notifier).book(
            rideId: ride.id,
            passengerId: user.id,
            passengerName: user.fullName ?? 'User',
            passengerPhone: user.phone,
            fromLocation: widget.searchFrom ?? ride.fromLocation,
            toLocation: widget.searchTo ?? ride.toLocation,
            fromLat: widget.searchFromLat,
            fromLng: widget.searchFromLng,
            toLat: widget.searchToLat,
            toLng: widget.searchToLng,
            seatsBooked: _seatsToBook,
            totalPrice: (ride.segmentPrice ?? ride.pricePerSeat) * _seatsToBook,
          );

      if (mounted) {
        // Use go() not push() — /my-bookings is inside ShellRoute
        context.go('/my-bookings');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ride booked successfully! Driver has been notified.')),
        );

        // --- BACKGROUND: SEND NOTIFICATIONS (CHAT + TABLE) ---
        _sendBackgroundNotifications(ride, user, _seatsToBook);
      }
    } catch (e) {
      if (mounted) {
        String errorMsg = e.toString().replaceAll('Exception: ', '');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Booking Failed: $errorMsg'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isBooking = false);
    }
  }

  Future<void> _sendBackgroundNotifications(RideModel ride, dynamic user, int seats) async {
    try {
      final ref = this.ref; // Capture ref
      
      // 1. Chat Notification
      final chatId = await ref.read(chatActionsProvider).getOrCreateChat(
        otherUserId: ride.driverId,
        rideId: ride.id,
      );
      final bookingMsg = '🔔 New Booking Alert!\n'
             'User: ${user.fullName}\n'
             'Seats: $seats\n'
             'From: ${widget.searchFrom ?? ride.fromLocation}\n'
             'To: ${widget.searchTo ?? ride.toLocation}\n'
             'Price: ₹${((ride.segmentPrice ?? ride.pricePerSeat) * seats).toStringAsFixed(0)}';
      
      await ref.read(chatActionsProvider).sendMessage(
        chatId: chatId,
        text: bookingMsg,
      );

      // Note: DB trigger in book_ride_seat already sends driver notification
      // Only send passenger confirmation here

      // Database Notification Entry for Passenger
      await ref.read(notificationActionsProvider).sendNotification(
        userId: user.id,
        title: 'Ride Booked! 🎉',
        message: 'You successfully booked $seats seat(s) for the ride with ${ride.driverName}.',
        type: 'booking_confirmed',
        rideId: ride.id,
      );
    } catch (e) {
      debugPrint('Silent notification error: $e');
    }
  }

  Future<void> _handleChat(WidgetRef ref) async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) {
      context.go('/login');
      return;
    }

    final rideAsync = ref.read(rideDetailsProvider(widget.rideId));
    final ride = rideAsync.value;
    if (ride == null) return;

    if (ride.driverId == user.id) return;

    try {
      final chatId = await ref.read(chatActionsProvider).getOrCreateChat(
            otherUserId: ride.driverId,
            rideId: ride.id,
            bookingId: '', // Optional
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

  @override
  Widget build(BuildContext context) {
    final rideAsync = ref.watch(rideDetailsProvider(widget.rideId));
    final dateFormat = DateFormat('EEEE, d MMMM y • hh:mm a');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ride Details'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              final ride = rideAsync.value;
              if (ride != null) {
                _shareRide(ride);
              }
            },
          ),
        ],
      ),
      body: rideAsync.when(
        data: (originalRide) {
          if (originalRide == null) {
            return const Center(child: Text('Ride not found'));
          }

          // Recalculate segment details if search coordinates are provided
          // This ensures pro-rata price is shown on details page too
          RideModel ride = originalRide;
          if (widget.searchFromLat != null && widget.searchToLat != null) {
            final segmentRide = RideService.calculateRideSegment(
              ride: originalRide,
              searchFromLat: widget.searchFromLat!,
              searchFromLng: widget.searchFromLng!,
              searchToLat: widget.searchToLat!,
              searchToLng: widget.searchToLng!,
            );
            if (segmentRide != null) {
              ride = segmentRide;
            }
          }
          // Store for booking — so _handleBooking uses segment price
          _calculatedRide = ride;

          // Fetch route if not already loaded
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _fetchRoute(ride);
          });

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Driver Profile Header
                Container(
                  padding: const EdgeInsets.all(24),
                  color: AppColors.primaryLight.withValues(alpha: 0.3),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: (ride.driverPhotoUrl != null && ride.driverPhotoUrl!.isNotEmpty)
                            ? CachedNetworkImageProvider(ride.driverPhotoUrl!)
                            : null,
                        child: (ride.driverPhotoUrl == null || ride.driverPhotoUrl!.isEmpty)
                            ? const Icon(Icons.person, size: 40)
                            : null,
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ride.driverName,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.star,
                                    size: 18, color: Colors.amber),
                                const SizedBox(width: 4),
                                Text(
                                  ride.driverRating.toStringAsFixed(1),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                if (ride.vehicleType != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.blue[100],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      ride.vehicleType!,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.blue[800],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                if (ride.isInPast)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    color: Colors.red[50],
                    child: const Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, color: Colors.red, size: 20),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'This ride has already departed and is no longer available for booking.',
                            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Route Detail
                      const Text(
                        'Route Map',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        height: 250,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: _isLoadingRoute 
                          ? const Center(child: CircularProgressIndicator())
                          : FlutterMap(
                              mapController: _mapController,
                              options: MapOptions(
                                initialCenter: _startCoord ?? const LatLng(28.6139, 77.2090),
                                initialZoom: 6,
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
                                      // Border Polyline (Shadow/Outline)
                                      Polyline(
                                        points: _routePoints,
                                        color: Colors.blue[900]!.withValues(alpha: 0.3),
                                        strokeWidth: 8,
                                      ),
                                      // Main Polyline
                                      Polyline(
                                        points: _routePoints,
                                        color: AppColors.primary,
                                        strokeWidth: 5,
                                      ),
                                    ],
                                  ),
                                  MarkerLayer(
                                    markers: [
                                      // Start Marker
                                      if (_startCoord != null)
                                        Marker(
                                          point: _startCoord!,
                                          child: const Column(
                                            children: [
                                              Icon(Icons.circle, color: AppColors.primary, size: 14),
                                              Text('Start', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary)),
                                            ],
                                          ),
                                        ),
                                      // End Marker
                                      if (_endCoord != null)
                                        Marker(
                                          point: _endCoord!,
                                          width: 40,
                                          height: 40,
                                          child: const Column(
                                            children: [
                                              Icon(Icons.location_on, color: AppColors.secondary, size: 24),
                                              Text('End', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.secondary)),
                                            ],
                                          ),
                                        ),
                                      // User's Joining Marker (Search 'From')
                                      if (widget.searchFromLat != null && widget.searchFromLng != null)
                                        Marker(
                                          point: LatLng(widget.searchFromLat!, widget.searchFromLng!),
                                          child: const Icon(Icons.person_pin_circle, color: Colors.blue, size: 30),
                                        ),
                                      // User's Dropping Marker (Search 'To')
                                      if (widget.searchToLat != null && widget.searchToLng != null)
                                        Marker(
                                          point: LatLng(widget.searchToLat!, widget.searchToLng!),
                                          child: const Icon(Icons.flag_rounded, color: Colors.green, size: 30),
                                        ),
                                    ],
                                  ),
                              ],
                            ),
                      ),
                      const SizedBox(height: 32),
                      
                      // Distance and Duration
                      Row(
                        children: [
                          _buildStatChip(Icons.straighten, '${ride.distanceKm?.toStringAsFixed(1) ?? "--"} km'),
                          const SizedBox(width: 12),
                          _buildStatChip(Icons.access_time, '${ride.durationMins ?? "--"} mins'),
                        ],
                      ),
                      
                      const SizedBox(height: 32),
                      const Text(
                        'Full Route Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Original Trip: ${ride.fromLocation} to ${ride.toLocation}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14, fontStyle: FontStyle.italic),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Column(
                            children: [
                              const Icon(Icons.circle_outlined,
                                  size: 24, color: AppColors.primary),
                              Container(
                                width: 2,
                                height: 40,
                                color: Colors.grey[300],
                              ),
                              const Icon(Icons.location_on,
                                  size: 24, color: AppColors.secondary),
                            ],
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ride.fromLocation,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 40),
                                Text(
                                  ride.toLocation,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),
                      const Divider(),
                      const SizedBox(height: 24),

                      // Time & Date
                      _buildInfoRow(
                        icon: Icons.calendar_today,
                        label: 'Departure',
                        value: dateFormat.format(ride.departureDatetime),
                      ),
                      const SizedBox(height: 16),

                      // Seats
                      _buildInfoRow(
                        icon: Icons.airline_seat_recline_normal,
                        label: 'Available Seats',
                        value: '${ride.availableSeats} of ${ride.totalSeats}',
                      ),
                      const SizedBox(height: 16),

                      // Price
                      _buildInfoRow(
                        icon: Icons.payments_outlined,
                        label: AppLocalizations.of(context)!.price_per_seat,
                        value: ride.formattedPrice,
                      ),

                      if (ride.description != null &&
                          ride.description!.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        const Text(
                          'Driver\'s Note',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          ride.description!,
                          style: const TextStyle(
                            fontSize: 15,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],

                      const SizedBox(height: 32),
                      const Divider(),
                      const SizedBox(height: 24),

                      // Trip Rules / Preferences
                      const Text(
                        'Trip Rules & Preferences',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 20,
                        runSpacing: 16,
                        children: [
                          _buildPreferenceIcon(Icons.smoke_free, 'No Smoking', ride.ruleNoSmoking),
                          _buildPreferenceIcon(Icons.music_off, 'No Music', ride.ruleNoMusic),
                          _buildPreferenceIcon(Icons.badge_outlined, 'No Heavy Bag', ride.ruleNoHeavyLuggage),
                          _buildPreferenceIcon(Icons.pets_outlined, 'No Pets', ride.ruleNoPets),
                          _buildPreferenceIcon(Icons.handshake_outlined, 'Negotiable', ride.ruleNegotiation),
                        ],
                      ),

                      const SizedBox(height: 32),
                      const Divider(),
                      const SizedBox(height: 24),

                      // Publisher (Driver) Details
                      const Text(
                        'Publisher Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Consumer(
                        builder: (context, ref, child) {
                          final driverAsync = ref.watch(userProfileProvider(ride.driverId));
                          return driverAsync.when(
                            data: (driver) {
                              if (driver == null) return const Text('Driver details not found');
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: CircleAvatar(
                                      radius: 25,
                                      backgroundImage: driver.photoUrl != null
                                          ? CachedNetworkImageProvider(driver.photoUrl!)
                                          : null,
                                      child: driver.photoUrl == null ? const Icon(Icons.person) : null,
                                    ),
                                    title: Text(driver.fullName ?? 'Unknown', style: const TextStyle(fontWeight: FontWeight.bold)),
                                    subtitle: Row(
                                      children: [
                                        const Icon(Icons.star, size: 16, color: Colors.amber),
                                        Text(' ${driver.rating} • ${driver.totalRidesGiven} rides given'),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  _buildDetailRow(Icons.history, 'Experience', driver.drivingExperience ?? 'Not specified'),
                                  _buildDetailRow(Icons.home_outlined, 'Address', driver.address ?? 'Not specified'),
                                  _buildDetailRow(Icons.directions_car_outlined, 'Vehicle', '${driver.vehicleColor ?? ""} ${driver.vehicleModel ?? "Not specified"}'),
                                ],
                              );
                            },
                            loading: () => const LinearProgressIndicator(),
                            error: (e, _) => Text('Error loading driver: $e'),
                          );
                        },
                      ),

                      const SizedBox(height: 32),
                      const Divider(),
                      const SizedBox(height: 24),

                      // Seat Selector
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Book Seats',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: _seatsToBook > 1
                                      ? () =>
                                          setState(() => _seatsToBook--)
                                      : null,
                                  icon: const Icon(Icons.remove),
                                ),
                                Text(
                                  '$_seatsToBook',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  onPressed: _seatsToBook < ride.availableSeats
                                      ? () =>
                                          setState(() => _seatsToBook++)
                                      : null,
                                  icon: const Icon(Icons.add),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 100), // Space for bottom bar
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      bottomSheet: rideAsync.maybeWhen(
        data: (ride) {
          if (ride == null) return null;
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _handleChat(ref),
                    icon: const Icon(Icons.chat_bubble_outline),
                    label: const Text('Chat'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      side: const BorderSide(color: AppColors.primary),
                      foregroundColor: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed:
                        _isBooking || !ride.canBook ? null : () => _handleBooking(ref),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isBooking
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            ride.isInPast 
                                ? 'Departed' 
                                : ride.isBookingClosed
                                    ? AppLocalizations.of(context)!.booking_closed
                                    : ride.availableSeats == 0 
                                        ? 'Seats Full' 
                                        : 'Book for ₹${((ride.segmentPrice ?? ride.pricePerSeat) * _seatsToBook).toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          );
        },
        orElse: () => null,
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildPreferenceIcon(IconData icon, String label, bool isEnabled) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isEnabled ? AppColors.primary : Colors.grey[300],
          size: 28,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isEnabled ? AppColors.textPrimary : Colors.grey[400],
            decoration: isEnabled ? null : TextDecoration.lineThrough,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 12),
          Text('$label: ', style: const TextStyle(color: AppColors.textSecondary)),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  void _shareRide(dynamic ride) {
    final text = 'Hey! Check out this ride from ${ride.from_location ?? ride.fromLocation} to ${ride.to_location ?? ride.toLocation} on ${DateFormat('EEE, d MMM').format(ride.departureDatetime)}. \n\nBook your seat on RideOn: [App Link]';
    Share.share(text, subject: 'Join this ride!');
  }
}
