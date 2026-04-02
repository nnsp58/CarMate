import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:geolocator/geolocator.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/notification_provider.dart';
import '../../providers/auth_provider.dart';
import '../../core/utils/cached_tile_provider.dart';
import '../../widgets/sos_button.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final MapController _mapController = MapController();
  final LatLng _defaultPosition = const LatLng(28.6139, 77.2090); // Delhi fallback
  LatLng? _currentPosition;
  bool _hasMovedToCurrent = false;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      if (permission == LocationPermission.deniedForever) return;

      final position = await Geolocator.getCurrentPosition().timeout(const Duration(seconds: 5));
      if (mounted) {
        setState(() {
          _currentPosition = LatLng(position.latitude, position.longitude);
        });
        
        // Auto-move only once on startup
        if (!_hasMovedToCurrent) {
          _mapController.move(_currentPosition!, 12);
          _hasMovedToCurrent = true;
        }
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  void _goToMyLocation() async {
    // Attempt to get fresh location
    await _initLocation();
    if (_currentPosition != null) {
      _mapController.move(_currentPosition!, 15);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not get your current location. Please check GPS.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider).value;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // 1. TOP HEADER CARD (Fixed white card, not transparent)
          _buildTopHeader(user),

          // 2. MAP SECTION (Middle)
          Expanded(
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _currentPosition ?? _defaultPosition,
                    initialZoom: 12,
                    onPositionChanged: (pos, hasGesture) {
                      // rotation is handled by controller
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.rideon.app',
                      tileProvider: CachedTileProvider(),
                    ),
                    MarkerLayer(
                      markers: [
                        if (_currentPosition != null)
                          Marker(
                            point: _currentPosition!,
                            width: 60,
                            height: 60,
                            child: Hero(
                              tag: 'userMarker',
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 3),
                                  boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
                                ),
                                child: CircleAvatar(
                                  radius: 28,
                                  backgroundColor: AppColors.primary,
                                  backgroundImage: user?.photoUrl != null
                                      ? CachedNetworkImageProvider(user!.photoUrl!)
                                      : null,
                                  child: user?.photoUrl == null
                                      ? const Icon(Icons.person, color: Colors.white)
                                      : null,
                                ),
                              ),
                            ),
                          ),
                        // Removed the static Delhi marker to avoid confusion
                      ],
                    ),
                  ],
                ),

                // SOS Button — bottom left
                const Positioned(
                  bottom: 20,
                  left: 20,
                  child: SOSButton(),
                ),

                // Map Controls — bottom right
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: Column(
                    children: [
                      _buildMapButton(
                        Icons.my_location,
                        _goToMyLocation,
                      ),
                      const SizedBox(height: 12),
                      _buildMapButton(
                        Icons.notifications_outlined,
                        () => context.push('/notifications'),
                        isNotification: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapButton(IconData icon, VoidCallback onTap, {bool isNotification = false}) {
    return Consumer(
      builder: (context, ref, child) {
        final notificationsAsync = ref.watch(myNotificationsProvider);
        final unreadCount = notificationsAsync.maybeWhen(
          data: (notes) => notes.where((n) => !(n['is_read'] as bool)).length,
          orElse: () => 0,
        );

        return Stack(
          clipBehavior: Clip.none,
          children: [
            FloatingActionButton.small(
              heroTag: null,
              onPressed: onTap,
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              child: Icon(icon),
            ),
            if (isNotification && unreadCount > 0)
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    unreadCount > 9 ? '9+' : unreadCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildTopHeader(user) {
    return Container(
      padding: const EdgeInsets.only(top: 50, left: 24, right: 24, bottom: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, ${user?.fullName?.split(' ').first ?? 'User'}! 👋',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Where are you going today?',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => context.go('/profile'),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.2), width: 2),
                  ),
                  child: CircleAvatar(
                    radius: 26,
                    backgroundColor: AppColors.primaryLight,
                    backgroundImage: user?.photoUrl != null
                        ? CachedNetworkImageProvider(user!.photoUrl!)
                        : null,
                    child: user?.photoUrl == null
                        ? const Icon(Icons.person, color: AppColors.primary)
                        : null,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildSearchCard(),
        ],
      ),
    );
  }



  Widget _buildSearchCard() {
    return GestureDetector(
      onTap: () => context.push('/search'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 15,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: const Row(
          children: [
            Icon(Icons.search, color: AppColors.primary, size: 24),
            SizedBox(width: 15),
            Expanded(
              child: Text(
                'Search for a matching ride...',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.tune, color: AppColors.primary, size: 20),
          ],
        ),
      ),
    );
  }
}
