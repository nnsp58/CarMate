import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/ride_provider.dart';
import '../../services/map_service.dart';
import '../../widgets/ride_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/location_search_field.dart';
import 'package:rideon/l10n/app_localizations.dart';

class SearchRidesScreen extends ConsumerStatefulWidget {
  const SearchRidesScreen({super.key});

  @override
  ConsumerState<SearchRidesScreen> createState() => _SearchRidesScreenState();
}

class _SearchRidesScreenState extends ConsumerState<SearchRidesScreen> {
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Safety check: Ensure search date is today or future, 
    // especially if app was left open overnight
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  double? _fromLat, _fromLng, _toLat, _toLng;

  bool _isGeocoding = false;

  Future<void> _onSearch() async {
    if (_fromController.text.isEmpty || _toController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both locations')),
      );
      return;
    }

    setState(() => _isGeocoding = true);

    try {
      // 1. Geocode locations if coordinates are missing (didn't select from list)
      if (_fromLat == null || _fromLng == null) {
        final res = await MapService.searchPlaces(_fromController.text);
        if (res.isNotEmpty) {
          _fromLat = res[0]['lat'];
          _fromLng = res[0]['lon'];
        }
      }

      if (_toLat == null || _toLng == null) {
        final res = await MapService.searchPlaces(_toController.text);
        if (res.isNotEmpty) {
          _toLat = res[0]['lat'];
          _toLng = res[0]['lon'];
        }
      }

      final user = ref.read(currentUserProvider).value;

      // 2. Perform searching
      await ref.read(rideSearchProvider.notifier).search(
            from: _fromController.text.trim(),
            to: _toController.text.trim(),
            fromLat: _fromLat,
            fromLng: _fromLng,
            toLat: _toLat,
            toLng: _toLng,
            date: _selectedDate,
            userId: user?.id,
          );
    } catch (e) {
      String errorMessage = 'Search failed: ${e.toString().replaceAll('Exception: ', '')}';
      if (e.toString().contains('PostgrestException')) {
        errorMessage = 'Search failed: ${e.toString().split('message: ').last.split(',').first}';
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isGeocoding = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchResults = ref.watch(rideSearchProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.search_rides),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Search Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(32),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                KeyedSubtree(
                  key: const Key('search_from_field'),
                  child: LocationSearchField(
                    label: AppLocalizations.of(context)!.from,
                    hint: 'Starting city/location',
                    icon: Icons.circle_outlined,
                    controller: _fromController,
                    onSelected: (name, lat, lon) {
                      _fromLat = lat;
                      _fromLng = lon;
                    },
                  ),
                ),
                const SizedBox(height: 12),
                KeyedSubtree(
                  key: const Key('search_to_field'),
                  child: LocationSearchField(
                    label: AppLocalizations.of(context)!.to,
                    hint: 'Destination city/location',
                    icon: Icons.location_on,
                    controller: _toController,
                    onSelected: (name, lat, lon) {
                      _toLat = lat;
                      _toLng = lon;
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectDate(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  size: 20, color: AppColors.primary),
                              const SizedBox(width: 12),
                              Text(
                                DateFormat('EEE, MMM d').format(_selectedDate),
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      key: const Key('search_button'),
                      onPressed: _onSearch,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: (_isGeocoding || searchResults.isLoading)
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              AppLocalizations.of(context)!.search,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Results Section
          Expanded(
            child: searchResults.when(
              data: (rides) {
                if (rides.isEmpty) {
                  return const EmptyState(
                    title: 'No rides found',
                    message: 'Try changing locations or date',
                    icon: Icons.search_off,
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: rides.length,
                  itemBuilder: (context, index) {
                    final ride = rides[index];
                    return KeyedSubtree(
                      key: const Key('search_ride_card'),
                      child: RideCard(
                        ride: ride,
                      onTap: () {
                        final uri = Uri(
                          path: '/ride-details/${ride.id}',
                          queryParameters: {
                            if (_fromController.text.isNotEmpty) 'from': _fromController.text,
                            if (_toController.text.isNotEmpty) 'to': _toController.text,
                            if (_fromLat != null) 'fromLat': _fromLat.toString(),
                            if (_fromLng != null) 'fromLng': _fromLng.toString(),
                            if (_toLat != null) 'toLat': _toLat.toString(),
                            if (_toLng != null) 'toLng': _toLng.toString(),
                          },
                        );
                        context.push(uri.toString());
                      },
                    ),
                  );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => EmptyState(
                title: 'Search Failed',
                message: err.toString().replaceAll('Exception: ', ''),
                icon: Icons.error_outline,
                actionLabel: 'Try Again',
                onAction: _onSearch,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
