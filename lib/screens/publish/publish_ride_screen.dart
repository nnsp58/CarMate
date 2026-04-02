import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import '../../services/map_service.dart';
import 'route_viewer_screen.dart';
import '../../core/constants/app_colors.dart';
import 'package:flutter_map/flutter_map.dart';
import '../../providers/auth_provider.dart';
import '../../providers/ride_provider.dart';
import '../../models/ride_model.dart';
import '../../services/ride_service.dart';
import '../../widgets/location_search_field.dart';
import '../../core/utils/cached_tile_provider.dart';

class PublishRideScreen extends ConsumerStatefulWidget {
  final RideModel? ride;
  const PublishRideScreen({super.key, this.ride});

  @override
  ConsumerState<PublishRideScreen> createState() => _PublishRideScreenState();
}

class _PublishRideScreenState extends ConsumerState<PublishRideScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  final _rcController = TextEditingController();
  final _dlController = TextEditingController();
  final _pucController = TextEditingController();
  final _insController = TextEditingController();
  bool _isInit = false;

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime =
      TimeOfDay.fromDateTime(DateTime.now().add(const Duration(minutes: 31)));
  int _availableSeats = 3;
  bool _isLoading = false;

  // Route state
  List<RouteOption> _suggestedRoutes = [];
  RouteOption? _selectedRoute;
  bool _isFetchingRoutes = false;
  bool _isDuplicating = false;

  // ✅ FIX: These coords are ONLY set by LocationSearchField.onSelected or map drag
  // They must NEVER be overwritten by a fresh text search
  LatLng? _fromCoord;
  LatLng? _toCoord;
  bool _isDraggingFrom = false;
  bool _isDraggingTo = false;

  final MapController _mapController = MapController();
  double _currentZoom = 6.0;
  int _currentStep = 0;

  // ────────────────────────────────────────────────
  // STEP NAVIGATION
  // ────────────────────────────────────────────────
  void _nextStep() {
    if (_currentStep == 0) {
      // Validate route step before advancing
      if (_fromController.text.isEmpty || _toController.text.isEmpty) {
        _showSnack('Pehle From aur To fill karein', isError: true);
        return;
      }
      if (_fromCoord == null || _toCoord == null) {
        _showSnack('Locations pick karein ya search results mein se select karein', isError: true);
        return;
      }
      if (_selectedRoute == null) {
        _showSnack('Pehle "Find Best Routes" press karein aur ek route chunein', isError: true);
        return;
      }
    }
    if (_currentStep < 2) setState(() => _currentStep++);
  }

  void _prevStep() {
    if (_currentStep > 0) setState(() => _currentStep--);
  }

  void _showSnack(String msg, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? AppColors.error : AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ────────────────────────────────────────────────
  // MAP CONTROLS
  // ────────────────────────────────────────────────
  void _zoomIn() {
    _currentZoom = (_currentZoom + 1).clamp(1.0, 18.0);
    _mapController.move(_mapController.camera.center, _currentZoom);
    setState(() {});
  }

  void _zoomOut() {
    _currentZoom = (_currentZoom - 1).clamp(1.0, 18.0);
    _mapController.move(_mapController.camera.center, _currentZoom);
    setState(() {});
  }

  void _fitRouteBounds() {
    if (_suggestedRoutes.isEmpty) return;

    final List<LatLng> allPoints = [];
    for (var route in _suggestedRoutes) {
      allPoints.addAll(route.points);
    }
    // Also include the user's pin locations
    if (_fromCoord != null) allPoints.add(_fromCoord!);
    if (_toCoord != null) allPoints.add(_toCoord!);

    if (allPoints.isEmpty) return;

    final bounds = LatLngBounds.fromPoints(allPoints);
    _mapController.fitCamera(
      CameraFit.bounds(
        bounds: bounds,
        padding: const EdgeInsets.all(60),
      ),
    );
  }

  // ────────────────────────────────────────────────
  // ✅ CORE FIX: _fetchRoutes — NEVER re-search from text
  // ────────────────────────────────────────────────
  Future<void> _fetchRoutes({bool forceSearch = false}) async {
    // ✅ FIX 1: Only geocode from text if we do NOT already have coords
    // When user selects from suggestions or map picker, coords are already set
    // forceSearch is now only used for explicit text-based geocoding (e.g. first load)
    if (_fromCoord == null || _toCoord == null || forceSearch) {
      // Only geocode if coords are missing — never overwrite user-set pins
      if (_fromCoord == null) {
        if (_fromController.text.isEmpty) {
          _showSnack('"From" location daalein', isError: true);
          return;
        }
        setState(() => _isFetchingRoutes = true);
        final fromRes = await MapService.searchPlaces(_fromController.text);
        if (fromRes.isNotEmpty) {
          _fromCoord = LatLng(
            (fromRes[0]['lat'] as num).toDouble(),
            (fromRes[0]['lon'] as num).toDouble(),
          );
        } else {
          _showSnack('"From" location nahi mili. Map pe pin drag karein.', isError: true);
          setState(() => _isFetchingRoutes = false);
          return;
        }
      }

      if (_toCoord == null) {
        if (_toController.text.isEmpty) {
          _showSnack('"To" location daalein', isError: true);
          setState(() => _isFetchingRoutes = false);
          return;
        }
        final toRes = await MapService.searchPlaces(_toController.text);
        if (toRes.isNotEmpty) {
          _toCoord = LatLng(
            (toRes[0]['lat'] as num).toDouble(),
            (toRes[0]['lon'] as num).toDouble(),
          );
        } else {
          _showSnack('"To" location nahi mili. Map pe pin drag karein.', isError: true);
          setState(() => _isFetchingRoutes = false);
          return;
        }
      }
    }

    // At this point we always have valid coords — fetch routes
    setState(() => _isFetchingRoutes = true);

    try {
      // ✅ FIX 2: Use the STORED coords (never pass text to geocoder again)
      final routes = await MapService.getDetailedRoutes(_fromCoord!, _toCoord!);
      setState(() {
        _suggestedRoutes = routes;
        if (routes.isNotEmpty) {
          _selectedRoute = routes[0];
          _updateSuggestedPrice(routes[0].distanceKm);
        }
      });

      // Fit bounds after fetching
      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted) _fitRouteBounds();
      });

      if (routes.isEmpty) {
        _showSnack('Koi route nahi mila. Pins ko adjust karein.', isError: true);
      }
    } catch (e) {
      debugPrint('Error fetching routes: $e');
      _showSnack('Route fetch karne mein error: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isFetchingRoutes = false);
    }
  }

  void _updateSuggestedPrice(double distanceKm) {
    final rawPrice = (distanceKm * 2).round();
    final roundedPrice = ((rawPrice + 4) ~/ 5) * 5;
    _priceController.text = roundedPrice.toString();
  }

  String _formatDuration(int totalMins) {
    if (totalMins < 0) return '00:00';
    final hours = totalMins ~/ 60;
    final mins = totalMins % 60;
    return '${hours.toString().padLeft(2, '0')}:${mins.toString().padLeft(2, '0')}';
  }

  void _showRouteSelectionOptions(RouteOption route) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Route Options',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '${route.name} (${route.distanceKm.toStringAsFixed(1)} km • ${_formatDuration(route.durationMins)})',
                style: TextStyle(color: Colors.grey[600], fontSize: 15),
              ),
              const SizedBox(height: 32),

              _buildOptionItem(
                icon: Icons.map_outlined,
                color: Colors.blue,
                title: 'Map pe dekho',
                subtitle: 'Poora route aur drawing dekho',
                onTap: () async {
                  Navigator.pop(context);
                  final selected = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RouteViewerScreen(
                        route: route,
                        fromLocation: _fromController.text,
                        toLocation: _toController.text,
                      ),
                    ),
                  );
                  if (selected == true) {
                    setState(() {
                      _selectedRoute = route;
                      _updateSuggestedPrice(route.distanceKm);
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              _buildOptionItem(
                icon: Icons.check_circle_outline,
                color: Colors.green,
                title: 'Yeh route chunein',
                subtitle: 'Is route ko apni ride ke liye confirm karein',
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedRoute = route;
                    _updateSuggestedPrice(route.distanceKm);
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildOptionItem(
                icon: Icons.close_rounded,
                color: Colors.grey,
                title: 'Dusra route dekho',
                subtitle: 'Baaki available routes dekho',
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOptionItem({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(subtitle,
                      style:
                          TextStyle(color: Colors.grey[600], fontSize: 13)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────
  // RULES STATE
  // ────────────────────────────────────────────────
  bool _ruleNoSmoking = false;
  bool _ruleNoMusic = false;
  bool _ruleNoHeavyLuggage = false;
  bool _ruleNoPets = false;
  bool _ruleNegotiation = false;

  Widget _buildRuleSwitch({
    required IconData icon,
    required String label,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      secondary: Icon(icon, color: value ? AppColors.primary : Colors.grey),
      title: Text(label, style: const TextStyle(fontSize: 15)),
      contentPadding: EdgeInsets.zero,
      activeThumbColor: AppColors.primary,
    );
  }

  // ────────────────────────────────────────────────
  // INIT
  // ────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    if (widget.ride != null) {
      final r = widget.ride!;
      _fromController.text = r.fromLocation;
      _toController.text = r.toLocation;
      _priceController.text = r.pricePerSeat.toStringAsFixed(0);
      _descriptionController.text = r.description ?? '';
      _availableSeats = r.totalSeats;
      _selectedDate = r.departureDatetime;
      _selectedTime = TimeOfDay.fromDateTime(r.departureDatetime);
      _ruleNoSmoking = r.ruleNoSmoking;
      _ruleNoMusic = r.ruleNoMusic;
      _ruleNoHeavyLuggage = r.ruleNoHeavyLuggage;
      _ruleNoPets = r.ruleNoPets;
      _ruleNegotiation = r.ruleNegotiation;

      // ✅ Use stored coords from ride model directly — no geocoding needed
      if (r.fromLat != null && r.fromLng != null) {
        _fromCoord = LatLng(r.fromLat ?? 0.0, r.fromLng ?? 0.0);
      }
      if (r.toLat != null && r.toLng != null) {
        _toCoord = LatLng(r.toLat ?? 0.0, r.toLng ?? 0.0);
      }
      _isInit = true;

      final isPast = r.departureDatetime.isBefore(DateTime.now());
      if (isPast) _isDuplicating = true;

      // Auto-fetch route for editing/duplicating
      if (_fromCoord != null && _toCoord != null) {
        Future.delayed(Duration.zero, () => _fetchRoutes());
      }
    } else {
      final now = DateTime.now();
      final suggestedDeparture = now.add(const Duration(minutes: 10));
      _selectedDate = DateTime(
          suggestedDeparture.year,
          suggestedDeparture.month,
          suggestedDeparture.day);
      _selectedTime = TimeOfDay.fromDateTime(suggestedDeparture);
    }

    Future.delayed(Duration.zero, () {
      final user = ref.read(currentUserProvider).value;
      if (user != null) {
        setState(() {
          if (_dlController.text.isEmpty) _dlController.text = user.drivingLicenseNumber ?? '';
          if (_rcController.text.isEmpty) _rcController.text = user.vehicleLicensePlate ?? '';
          if (_pucController.text.isEmpty) _pucController.text = user.pucNumber ?? '';
          if (_insController.text.isEmpty) _insController.text = user.insuranceNumber ?? '';

          if (widget.ride == null) {
            _ruleNoSmoking = user.prefNoSmoking;
            _ruleNoMusic = user.prefNoMusic;
            _ruleNoHeavyLuggage = user.prefNoHeavyLuggage;
            _ruleNoPets = user.prefNoPets;
            _ruleNegotiation = user.prefNegotiation;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _rcController.dispose();
    _dlController.dispose();
    _pucController.dispose();
    _insController.dispose();
    super.dispose();
  }

  bool _validateGap({DateTime? date, TimeOfDay? time}) {
    final now = DateTime.now();
    final d = date ?? _selectedDate;
    final t = time ?? _selectedTime;

    final departureTime =
        DateTime(d.year, d.month, d.day, t.hour, t.minute);
    final diffInMins = departureTime.difference(now).inMinutes;

    if (diffInMins < 5) {
      _showSnack(
        diffInMins < 0
            ? 'Warning: Departure time past mein hai!'
            : 'Warning: Kam se kam 5 minutes baad ka time chunein (gap: $diffInMins mins)',
        isError: true,
      );
      return false;
    }
    return true;
  }

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate.isBefore(now) ? now : _selectedDate,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: now.add(const Duration(days: 30)),
    );
    if (picked != null) {
      final t = _selectedTime;
      final departureTime =
          DateTime(picked.year, picked.month, picked.day, t.hour, t.minute);

      if (departureTime
          .isBefore(DateTime.now().add(const Duration(minutes: 6)))) {
        final minValid = DateTime.now().add(const Duration(minutes: 6));
        setState(() {
          _selectedDate = picked;
          _selectedTime = TimeOfDay.fromDateTime(minValid);
        });
        _validateGap();
      } else {
        setState(() => _selectedDate = picked);
      }
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      if (!mounted) return;
      final now = DateTime.now();
      final departureTime = DateTime(_selectedDate.year, _selectedDate.month,
          _selectedDate.day, picked.hour, picked.minute);

      if (departureTime.difference(now).inMinutes < 5) {
        final minValid = DateTime.now().add(const Duration(minutes: 6));
        setState(() => _selectedTime = TimeOfDay.fromDateTime(minValid));
        _showSnack('Minimum 5 minutes ka gap hona chahiye', isError: true);
      } else {
        setState(() => _selectedTime = picked);
      }
    }
  }

  // ────────────────────────────────────────────────
  // PUBLISH
  // ────────────────────────────────────────────────
  Future<void> _onPublish() async {
    if (_isLoading) return;
    if (!_formKey.currentState!.validate()) return;

    final user = ref.read(currentUserProvider).value;
    if (user == null) return;

    if (user.photoUrl == null) {
      _showSnack('Profile Photo zaroori hai. Profile Setup mein add karein!',
          isError: true);
      return;
    }

    if (_dlController.text.trim().isEmpty ||
        _rcController.text.trim().isEmpty) {
      _showSnack('Driving License aur RC Number bhar kar submit karein.',
          isError: true);
      return;
    }

    if (!_validateGap()) return;

    // ✅ Ensure we have route
    if (_selectedRoute == null) {
      if (_suggestedRoutes.isNotEmpty) {
        _selectedRoute = _suggestedRoutes[0];
      } else if (_fromCoord != null && _toCoord != null) {
        _showSnack('Route fetch ho raha hai...', isError: false);
        await _fetchRoutes();
      }
      if (_selectedRoute == null) {
        _showSnack(
            'Route chunna zaroori hai. "Find Best Routes" press karein.',
            isError: true);
        return;
      }
    }

    // ✅ Ensure coordinates are set
    if (_fromCoord == null || _toCoord == null) {
      _showSnack(
          'From aur To locations confirm karein (pin icon se ya suggestion select karein)',
          isError: true);
      return;
    }

    final departureTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    setState(() => _isLoading = true);

    final distanceKm = _selectedRoute?.distanceKm;
    final durationMins = _selectedRoute?.durationMins;

    // ✅ Use pinned coords — not text search
    final fromLat = _fromCoord!.latitude;
    final fromLng = _fromCoord!.longitude;
    final toLat = _toCoord!.latitude;
    final toLng = _toCoord!.longitude;

    final routePointsJson = _selectedRoute?.points
        .map((p) => {'lat': p.latitude, 'lng': p.longitude})
        .toList();

    // AI Verification simulation
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Documents verify ho rahe hain...')),
    );
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    if (_dlController.text.length < 5 || _rcController.text.length < 5) {
      _showSnack(
          'Document numbers invalid hain. Sahi numbers daalein.',
          isError: true);
      setState(() => _isLoading = false);
      return;
    }

    _showSnack('Documents verified! Ride publish ho rahi hai...');

    try {
      await ref.read(authActionsProvider).updateProfile(
        userId: user.id,
        data: {
          'vehicle_license_plate': _rcController.text.trim(),
          'driving_license_number': _dlController.text.trim(),
          'puc_number': _pucController.text.trim(),
          'insurance_number': _insController.text.trim(),
          'pref_no_smoking': _ruleNoSmoking,
          'pref_no_music': _ruleNoMusic,
          'pref_no_heavy_luggage': _ruleNoHeavyLuggage,
          'pref_no_pets': _ruleNoPets,
          'pref_negotiation': _ruleNegotiation,
        },
      );

      if (widget.ride != null && !_isDuplicating) {
        final updates = {
          'from_location': _fromController.text.trim(),
          'to_location': _toController.text.trim(),
          'from_lat': fromLat,
          'from_lng': fromLng,
          'to_lat': toLat,
          'to_lng': toLng,
          'departure_datetime': departureTime.toIso8601String(),
          'available_seats': _availableSeats,
          'total_seats': _availableSeats,
          'price_per_seat': double.parse(_priceController.text.trim()),
          'description': _descriptionController.text.trim(),
          'route_points': routePointsJson,
          'distance_km': distanceKm,
          'duration_mins': durationMins,
          'rule_no_smoking': _ruleNoSmoking,
          'rule_no_music': _ruleNoMusic,
          'rule_no_heavy_luggage': _ruleNoHeavyLuggage,
          'rule_no_pets': _ruleNoPets,
          'rule_negotiation': _ruleNegotiation,
          'status': 'active',
          'updated_at': DateTime.now().toIso8601String(),
        };
        await RideService.updateRide(
            rideId: widget.ride!.id, driverId: user.id, updates: updates);
        ref.invalidate(myPublishedRidesProvider);
        ref.invalidate(rideDetailsProvider(widget.ride!.id));
      } else {
        final ride = RideModel(
          id: '',
          driverId: user.id,
          driverName: user.fullName ?? 'User',
          driverPhotoUrl: user.photoUrl,
          driverRating: user.rating,
          fromLocation: _fromController.text.trim(),
          toLocation: _toController.text.trim(),
          fromLat: fromLat,
          fromLng: fromLng,
          toLat: toLat,
          toLng: toLng,
          departureDatetime: departureTime,
          availableSeats: _availableSeats,
          totalSeats: _availableSeats,
          pricePerSeat: double.parse(_priceController.text.trim()),
          vehicleInfo: '${user.vehicleColor ?? ''} ${user.vehicleModel ?? ''}'.trim(),
          vehicleType: user.vehicleType,
          description: _descriptionController.text.trim(),
          routePointsJson: routePointsJson,
          distanceKm: distanceKm,
          durationMins: durationMins,
          ruleNoSmoking: _ruleNoSmoking,
          ruleNoMusic: _ruleNoMusic,
          ruleNoHeavyLuggage: _ruleNoHeavyLuggage,
          ruleNoPets: _ruleNoPets,
          ruleNegotiation: _ruleNegotiation,
          status: 'active',
          createdAt: DateTime.now(),
        );

        await ref.read(publishRideProvider.notifier).publish(ride);
      }

      if (mounted) {
        final msg = (widget.ride != null && !_isDuplicating)
            ? 'Ride update ho gayi! 🎉'
            : 'Ride publish ho gayi! 🎉';
        _showSnack(msg);
        ref.invalidate(myPublishedRidesProvider);
        context.go('/my-rides');
      }
    } catch (e) {
      if (mounted) {
        _showSnack('Ride publish karne mein error: $e', isError: true);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ────────────────────────────────────────────────
  // BUILD
  // ────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider).value;

    if (!_isInit && user != null) {
      _rcController.text = user.vehicleLicensePlate ?? '';
      _dlController.text = user.drivingLicenseNumber ?? '';
      _pucController.text = user.pucNumber ?? '';
      _insController.text = user.insuranceNumber ?? '';
      _ruleNoSmoking = user.prefNoSmoking;
      _ruleNoMusic = user.prefNoMusic;
      _ruleNoHeavyLuggage = user.prefNoHeavyLuggage;
      _ruleNoPets = user.prefNoPets;
      _ruleNegotiation = user.prefNegotiation;
      _isInit = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text((widget.ride != null && !_isDuplicating)
            ? 'Ride Edit Karein'
            : 'Ride Publish Karein'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                'Step ${_currentStep + 1}/3',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.white70),
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: IndexedStack(
                        index: _currentStep,
                        children: [
                          _buildRouteStep(),
                          _buildTripStep(),
                          _buildRulesStep(),
                        ],
                      ),
                    ),
                  ),

                  // NAVIGATION BUTTONS COMPACT
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, -2)),
                      ],
                    ),
                    child: Row(
                      children: [
                        if (_currentStep > 0)
                          IconButton(
                            onPressed: _prevStep,
                            icon: const Icon(Icons.arrow_back_ios_new,
                                color: Colors.grey, size: 18),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.grey[100],
                              padding: const EdgeInsets.all(10),
                            ),
                          ),
                        if (_currentStep > 0)
                          const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _currentStep < 2 ? _nextStep : _onPublish,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(
                              _currentStep < 2
                                  ? 'CONTINUE'
                                  : ((widget.ride != null && !_isDuplicating)
                                      ? 'RIDE UPDATE KAREIN'
                                      : 'RIDE PUBLISH KAREIN'),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // ────────────────────────────────────────────────
  // STEP 1: ROUTE
  // ────────────────────────────────────────────────
  Widget _buildRouteStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Helper tip removed as per user request

        LocationSearchField(
          label: 'From (Starting Point)',
          hint: 'e.g. Ghaziabad, UP',
          icon: Icons.my_location,
          controller: _fromController,
          onSelected: (name, lat, lon) {
            // ✅ Coords set here — from selection or map picker
            setState(() {
              _fromCoord = LatLng(lat, lon);
              _suggestedRoutes = []; // Clear old routes
              _selectedRoute = null;
            });
            // Move map to from location
            _mapController.move(_fromCoord!, 12.0);
          },
        ),
        const SizedBox(height: 16),

        LocationSearchField(
          label: 'To (Destination)',
          hint: 'e.g. Kannauj, UP',
          icon: Icons.location_on,
          controller: _toController,
          onSelected: (name, lat, lon) {
            // ✅ Coords set here — from selection or map picker
            setState(() {
              _toCoord = LatLng(lat, lon);
              _suggestedRoutes = [];
              _selectedRoute = null;
            });
            // ✅ Auto-zoom to show both pins if from is also set
            if (_fromCoord != null) {
              Future.delayed(const Duration(milliseconds: 300), () {
                if (mounted) {
                  final bounds = LatLngBounds.fromPoints(
                      [_fromCoord!, LatLng(lat, lon)]);
                  _mapController.fitCamera(
                    CameraFit.bounds(
                        bounds: bounds,
                        padding: const EdgeInsets.all(80)),
                  );
                }
              });
            } else {
              _mapController.move(LatLng(lat, lon), 12.0);
            }
          },
        ),
        const SizedBox(height: 20),

        // Find Routes button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _isFetchingRoutes ? null : () => _fetchRoutes(),
            icon: _isFetchingRoutes
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.route, size: 18),
            label: Text(_isFetchingRoutes
                ? 'Wait...'
                : 'Best Route', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: (_fromCoord != null && _toCoord != null)
                  ? AppColors.primary
                  : Colors.grey[300],
              foregroundColor: (_fromCoord != null && _toCoord != null)
                  ? Colors.white
                  : Colors.grey,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),

        // Selected route info banner
        if (_selectedRoute != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: AppColors.success.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle,
                    color: AppColors.success, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${_selectedRoute!.name} • ${_selectedRoute!.distanceKm.toStringAsFixed(1)} km • ${_formatDuration(_selectedRoute!.durationMins)}',
                    style: const TextStyle(
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                        fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 16),

        // MAP PREVIEW
        Container(
          height: 320,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey[200]!),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4))
            ],
          ),
          child: Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter:
                      _fromCoord ?? const LatLng(26.8467, 80.9462), // UP center
                  initialZoom: _currentZoom,
                  interactionOptions: InteractionOptions(
                    flags: (_isDraggingFrom || _isDraggingTo)
                        ? InteractiveFlag.none
                        : InteractiveFlag.all,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.rideon.app',
                    tileProvider: CachedTileProvider(),
                  ),
                  _buildPolylines(),
                  _buildMarkers(),
                ],
              ),
              _buildZoomControls(),
              // Drag hint
              if (_fromCoord != null || _toCoord != null)
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '📍 Pin drag karke exact location set karein',
                      style: TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Route list
        if (_suggestedRoutes.isNotEmpty) ...[
          const SizedBox(height: 16),
          const Text('Suggested Routes:',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.grey)),
          const SizedBox(height: 8),
          _buildRouteList(),
        ],
      ],
    );
  }

  // ────────────────────────────────────────────────
  // STEP 2: TRIP DETAILS
  // ────────────────────────────────────────────────
  Widget _buildTripStep() {
    return Column(
      children: [
        // Route summary card
        if (_selectedRoute != null)
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.route, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_fromController.text} → ${_toController.text}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${_selectedRoute!.distanceKm.toStringAsFixed(0)} km • ${_formatDuration(_selectedRoute!.durationMins)}',
                        style: const TextStyle(
                            color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

        // Suggested fare
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.blue[100]!),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.blue),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Suggested Fare:',
                        style:
                            TextStyle(fontSize: 12, color: Colors.blue)),
                    Text(
                      '₹${_priceController.text}',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                    const Text(
                      'Aap neeche apna price adjust kar sakte hain',
                      style: TextStyle(fontSize: 11, color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),

        _buildSectionTitle('Safar kab hai?'),
        Row(
          children: [
            Expanded(
                child: _buildPickerCard(
              label: 'Date',
              value: DateFormat('MMM d, yyyy').format(_selectedDate),
              onTap: () => _selectDate(context),
              icon: Icons.calendar_today,
            )),
            const SizedBox(width: 16),
            Expanded(
                child: _buildPickerCard(
              label: 'Time',
              value: _selectedTime.format(context),
              onTap: () => _selectTime(context),
              icon: Icons.access_time,
            )),
          ],
        ),
        const SizedBox(height: 28),

        _buildSectionTitle('Seats & Price'),
        Row(
          children: [
            Expanded(child: _buildSeatPicker()),
            const SizedBox(width: 24),
            Expanded(child: _buildPriceInput()),
          ],
        ),
      ],
    );
  }

  // ────────────────────────────────────────────────
  // STEP 3: RULES
  // ────────────────────────────────────────────────
  Widget _buildRulesStep() {
    return Column(
      children: [
        _buildSectionTitle('Passenger Preferences'),
        _buildRuleSwitch(
          icon: Icons.smoke_free,
          label: 'No Smoking',
          value: _ruleNoSmoking,
          onChanged: (v) => setState(() => _ruleNoSmoking = v),
        ),
        _buildRuleSwitch(
          icon: Icons.music_off,
          label: 'No Music',
          value: _ruleNoMusic,
          onChanged: (v) => setState(() => _ruleNoMusic = v),
        ),
        _buildRuleSwitch(
          icon: Icons.badge_outlined,
          label: 'No Heavy Luggage',
          value: _ruleNoHeavyLuggage,
          onChanged: (v) => setState(() => _ruleNoHeavyLuggage = v),
        ),
        _buildRuleSwitch(
          icon: Icons.pets,
          label: 'No Pets',
          value: _ruleNoPets,
          onChanged: (v) => setState(() => _ruleNoPets = v),
        ),
        _buildRuleSwitch(
          icon: Icons.handshake_outlined,
          label: 'Price Negotiable',
          value: _ruleNegotiation,
          onChanged: (v) => setState(() => _ruleNegotiation = v),
        ),
        const SizedBox(height: 28),

        _buildSectionTitle('Driver Verification'),
        _buildDetailsFormSection(),
        const SizedBox(height: 28),

        _buildSectionTitle('Trip Notes (Optional)'),
        TextFormField(
          controller: _descriptionController,
          maxLines: 3,
          maxLength: 300,
          decoration: InputDecoration(
            hintText: 'e.g. Please reach on time. AC available...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
      ],
    );
  }

  // ────────────────────────────────────────────────
  // MAP WIDGETS
  // ────────────────────────────────────────────────
  Widget _buildPolylines() {
    return PolylineLayer(
      polylines: [
        // Unselected routes (grey)
        for (var route in _suggestedRoutes.where((r) => r != _selectedRoute))
          Polyline(
            points: route.points,
            color: Colors.grey.withValues(alpha: 0.35),
            strokeWidth: 4,
          ),
        // ✅ FIX 2: ONLY use the OSRM route points — do NOT manually add fromCoord/toCoord
        // Adding them caused the 40-50km jump because OSRM snaps to nearest road
        // The route.points already correctly start near the from pin and end near the to pin
        if (_selectedRoute != null && _selectedRoute!.points.isNotEmpty)
          Polyline(
            points: _selectedRoute!.points,
            color: AppColors.primary,
            strokeWidth: 6,
            strokeCap: StrokeCap.round,
            strokeJoin: StrokeJoin.round,
          ),
      ],
    );
  }

  Widget _buildMarkers() {
    return MarkerLayer(
      markers: [
        // FROM marker — draggable
        if (_fromCoord != null)
          Marker(
            point: _fromCoord!,
            width: 130,
            height: 70,
            child: GestureDetector(
              onPanStart: (_) => setState(() => _isDraggingFrom = true),
              onPanUpdate: (details) {
                final point =
                    _mapController.camera.latLngToScreenPoint(_fromCoord!);
                final newPoint = math.Point<double>(
                  (point.x + details.delta.dx).toDouble(),
                  (point.y + details.delta.dy).toDouble(),
                );
                final newLatLng =
                    _mapController.camera.pointToLatLng(newPoint);
                setState(() => _fromCoord = newLatLng);
              },
              onPanEnd: (_) async {
                setState(() => _isDraggingFrom = false);
                // ✅ Update text box with NEW address after drag
                final addr = await MapService.getAddressFromLatLng(_fromCoord!.latitude, _fromCoord!.longitude);
                setState(() => _fromController.text = addr);
                // ✅ After drag: re-fetch routes with stored coords
                _fetchRoutes(forceSearch: false);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black26, blurRadius: 4)
                      ],
                    ),
                    child: const Text('START',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary)),
                  ),
                  const Icon(Icons.location_on,
                      color: AppColors.primary, size: 42),
                ],
              ),
            ),
          ),

        // TO marker — draggable
        if (_toCoord != null)
          Marker(
            point: _toCoord!,
            width: 130,
            height: 70,
            child: GestureDetector(
              onPanStart: (_) => setState(() => _isDraggingTo = true),
              onPanUpdate: (details) {
                final point =
                    _mapController.camera.latLngToScreenPoint(_toCoord!);
                final newPoint = math.Point<double>(
                  (point.x + details.delta.dx).toDouble(),
                  (point.y + details.delta.dy).toDouble(),
                );
                final newLatLng =
                    _mapController.camera.pointToLatLng(newPoint);
                setState(() => _toCoord = newLatLng);
              },
              onPanEnd: (_) async {
                setState(() => _isDraggingTo = false);
                // ✅ Update text box with NEW address after drag
                final addr = await MapService.getAddressFromLatLng(_toCoord!.latitude, _toCoord!.longitude);
                setState(() => _toController.text = addr);
                // ✅ After drag: re-fetch routes with stored coords
                _fetchRoutes(forceSearch: false);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black26, blurRadius: 4)
                      ],
                    ),
                    child: const Text('END',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondary)),
                  ),
                  const Icon(Icons.flag,
                      color: AppColors.secondary, size: 42),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildZoomControls() {
    return Positioned(
      right: 12,
      top: 12,
      child: Column(
        children: [
          FloatingActionButton.small(
            heroTag: 'zIn',
            onPressed: _zoomIn,
            backgroundColor: Colors.white,
            child: const Icon(Icons.add, color: AppColors.primary),
          ),
          const SizedBox(height: 8),
          FloatingActionButton.small(
            heroTag: 'zOut',
            onPressed: _zoomOut,
            backgroundColor: Colors.white,
            child: const Icon(Icons.remove, color: AppColors.primary),
          ),
          const SizedBox(height: 8),
          FloatingActionButton.small(
            heroTag: 'zFit',
            onPressed: _fitRouteBounds,
            backgroundColor: Colors.white,
            tooltip: 'Fit route',
            child: const Icon(Icons.fit_screen, color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteList() {
    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _suggestedRoutes.length,
        itemBuilder: (context, index) {
          final r = _suggestedRoutes[index];
          final sel = _selectedRoute == r;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedRoute = r;
                _updateSuggestedPrice(r.distanceKm);
              });
            },
            onLongPress: () => _showRouteSelectionOptions(r),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: sel ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: sel ? AppColors.primary : Colors.grey[300]!),
                boxShadow: sel
                    ? [
                        BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2))
                      ]
                    : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(r.name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: sel ? Colors.white : Colors.black,
                          fontSize: 13)),
                  Text(
                    '${r.distanceKm.toStringAsFixed(0)} km • ${_formatDuration(r.durationMins)}',
                    style: TextStyle(
                        color: sel ? Colors.white70 : Colors.grey,
                        fontSize: 11),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ────────────────────────────────────────────────
  // HELPER UI COMPONENTS
  // ────────────────────────────────────────────────
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(title,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildPickerCard({
    required String label,
    required String value,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(icon, size: 16, color: AppColors.primary),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(value,
                      style:
                          const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeatPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Seats',
            style: TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: _availableSeats > 1
                    ? () => setState(() => _availableSeats--)
                    : null,
                icon: const Icon(Icons.remove),
              ),
              Text('$_availableSeats',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(
                onPressed: _availableSeats < 6
                    ? () => setState(() => _availableSeats++)
                    : null,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Price / Seat',
            style: TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 8),
        TextFormField(
          controller: _priceController,
          keyboardType: TextInputType.number,
          validator: (v) =>
              v == null || v.trim().isEmpty ? 'Price daalein' : null,
          decoration: InputDecoration(
            prefixText: '₹ ',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16)),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsFormSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
        color: Colors.grey[50],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Vehicle & Driver Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _rcController,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              labelText: 'Vehicle RC Number *',
              prefixIcon: const Icon(Icons.pin_outlined),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            validator: (value) =>
                value == null || value.trim().isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _dlController,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              labelText: 'Driving License Number *',
              prefixIcon: const Icon(Icons.badge_outlined),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            validator: (value) =>
                value == null || value.trim().isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _pucController,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              labelText: 'PUC Number (Optional)',
              prefixIcon: const Icon(Icons.receipt_long_outlined),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _insController,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              labelText: 'Insurance Number (Optional)',
              prefixIcon: const Icon(Icons.shield_outlined),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Note: Yeh details securely aapke profile mein save hongi.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
