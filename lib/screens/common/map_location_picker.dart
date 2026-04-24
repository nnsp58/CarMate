import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../../core/constants/app_colors.dart';
import '../../services/map_service.dart';
import '../../core/utils/cached_tile_provider.dart';

class MapLocationPicker extends StatefulWidget {
  final LatLng initialPosition;
  final String title;
  final bool useGpsIfNoInitial;

  const MapLocationPicker({
    super.key,
    this.initialPosition = const LatLng(28.6139, 77.2090), // Delhi default
    this.title = 'Select Location',
    this.useGpsIfNoInitial = true, // true = fetch GPS, false = use initialPosition directly
  });

  @override
  State<MapLocationPicker> createState() => _MapLocationPickerState();
}

class _MapLocationPickerState extends State<MapLocationPicker> {
  LatLng? _startPosition; // null = still loading GPS
  late LatLng _currentPosition;
  LatLng? _userGpsLocation;
  String _currentAddress = 'Getting your location...';
  bool _isIdling = true;
  bool _isLoadingGps = true;
  bool _mapReady = false;
  bool _isMapMoving = false; // Added to track map dragging state
  final MapController _mapController = MapController();
  double _mapRotation = 0;

  @override
  void initState() {
    super.initState();
    _currentPosition = widget.initialPosition;
    if (widget.useGpsIfNoInitial) {
      _initLocation();
    } else {
      // Use the provided initialPosition directly (e.g., user already selected a city)
      _finishInit(widget.initialPosition);
    }
  }

  Future<void> _initLocation() async {
    LatLng resolvedPosition = widget.initialPosition;

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _finishInit(resolvedPosition);
        return;
      }

      // Check permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _finishInit(resolvedPosition);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _finishInit(resolvedPosition);
        return;
      }

      // Get current position with timeout, fallback to last known
      Position? position;
      try {
        position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
        ).timeout(const Duration(seconds: 10));
      } catch (_) {
        position = await Geolocator.getLastKnownPosition();
      }

      if (position != null) {
        resolvedPosition = LatLng(position.latitude, position.longitude);
        _userGpsLocation = resolvedPosition;
      }
    } catch (e) {
      debugPrint('GPS Error: $e');
    }

    _finishInit(resolvedPosition);
  }

  void _finishInit(LatLng position) {
    if (!mounted) return;
    setState(() {
      _startPosition = position;
      _currentPosition = position;
      _userGpsLocation ??= null; // keep as is
      _isLoadingGps = false;
    });
    _reverseGeocode(position);
  }

  void _goToMyLocation() async {
    if (_userGpsLocation != null && _mapReady) {
      _mapController.move(_userGpsLocation!, 16);
      setState(() {
        _currentPosition = _userGpsLocation!;
      });
      _reverseGeocode(_userGpsLocation!);
    } else {
      // Try to fetch GPS again
      setState(() => _isLoadingGps = true);
      try {
        final position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
        ).timeout(const Duration(seconds: 10));

        final gpsLatLng = LatLng(position.latitude, position.longitude);
        if (mounted) {
          setState(() {
            _userGpsLocation = gpsLatLng;
            _currentPosition = gpsLatLng;
            _isLoadingGps = false;
          });
          if (_mapReady) {
            _mapController.move(gpsLatLng, 16);
          }
          _reverseGeocode(gpsLatLng);
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isLoadingGps = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not get GPS location. Please enable location services.')),
          );
        }
      }
    }
  }

  void _resetNorth() {
    if (_mapReady) {
      _mapController.rotate(0);
      setState(() => _mapRotation = 0);
    }
  }

  Future<void> _reverseGeocode(LatLng position) async {
    setState(() {
      _isIdling = false;
      _currentAddress = 'Fetching address...';
    });
    final address = await MapService.getAddressFromLatLng(
      position.latitude,
      position.longitude,
    );
    if (mounted) {
      setState(() {
        _currentAddress = address;
        _isIdling = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: _startPosition == null
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Getting your location...',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _startPosition!,
                    initialZoom: 16,
                    onMapReady: () {
                      _mapReady = true;
                    },
                    onPositionChanged: (position, hasGesture) {
                      if (hasGesture) {
                        setState(() {
                          _currentPosition = position.center;
                          if (!_isMapMoving) _isMapMoving = true;
                          _currentAddress = 'Moving...';
                          _mapRotation = position.rotation;
                        });
                      }
                    },
                    onMapEvent: (event) {
                      if (event is MapEventMoveEnd) {
                        setState(() {
                          _isMapMoving = false;
                        });
                        _reverseGeocode(_currentPosition);
                      }
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.rideon.app',
                      tileProvider: CachedTileProvider(),
                    ),
                    // GPS Location blue dot marker
                    if (_userGpsLocation != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _userGpsLocation!,
                            width: 28,
                            height: 28,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.blue, width: 2),
                              ),
                              child: const Center(
                                child: CircleAvatar(
                                  radius: 6,
                                  backgroundColor: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                
                // Fixed Center Marker (The "Pin" with jump animation)
                Center(
                  child: Transform.translate(
                    offset: const Offset(0, -22.5), // Offset by half the icon size (45/2) to place the bottom of the pin at the center
                    child: SizedBox(
                      width: 45,
                      height: 45,
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          // Small dot showing exact center position
                          const Positioned(
                            bottom: -2,
                            child: CircleAvatar(
                              radius: 4,
                              backgroundColor: Colors.black38,
                            ),
                          ),
                          // Bouncing pin icon
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOutCubic,
                            bottom: _isMapMoving ? 15 : 0,
                            child: const Icon(
                              Icons.location_on,
                              color: AppColors.secondary,
                              size: 45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Compass / North Indicator (top right)
                Positioned(
                  top: 16,
                  right: 16,
                  child: GestureDetector(
                    onTap: _resetNorth,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Transform.rotate(
                        angle: -_mapRotation * (3.14159265 / 180),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'N',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                                height: 1,
                              ),
                            ),
                            Icon(Icons.navigation, color: Colors.red, size: 20),
                            Text(
                              'S',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                height: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // My Location Button
                Positioned(
                  bottom: 180,
                  right: 16,
                  child: FloatingActionButton.small(
                    heroTag: 'myLocation',
                    onPressed: _goToMyLocation,
                    backgroundColor: Colors.white,
                    child: _isLoadingGps
                        ? const SizedBox(
                            width: 20, height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(
                            _userGpsLocation != null 
                                ? Icons.my_location 
                                : Icons.location_searching,
                            color: AppColors.primary,
                          ),
                  ),
                ),

                // Address Info Card
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 10),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'LOCATION DETAILS',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.place_outlined, color: AppColors.primary),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _currentAddress,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isIdling && !_isMapMoving
                                ? () {
                                    Navigator.pop(context, {
                                      'address': _currentAddress,
                                      'lat': _currentPosition.latitude,
                                      'lon': _currentPosition.longitude,
                                    });
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              'Confirm Location',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
