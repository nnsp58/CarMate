import 'dart:async';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../../services/map_service.dart';
import '../../core/constants/app_colors.dart';
import '../screens/common/map_location_picker.dart';

class LocationSearchField extends StatefulWidget {
  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final Function(String name, double lat, double lon) onSelected;

  const LocationSearchField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
    required this.onSelected,
  });

  @override
  State<LocationSearchField> createState() => _LocationSearchFieldState();
}

class _LocationSearchFieldState extends State<LocationSearchField> {
  List<Map<String, dynamic>> _suggestions = [];
  Timer? _debounce;
  bool _isLoading = false;
  bool _locationConfirmed = false; // ✅ Track if a location is confirmed

  // ✅ FIX: Store selected coords so map opens at the right place
  LatLng? _selectedCoords;

  void _onSearchChanged(String query) {
    // ✅ FIX: User is typing again — clear confirmed state
    if (_locationConfirmed) {
      setState(() => _locationConfirmed = false);
    }

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () async {
      if (query.length < 3) {
        setState(() => _suggestions = []);
        return;
      }

      setState(() => _isLoading = true);
      final results = await MapService.searchPlaces(query);
      if (mounted) {
        setState(() {
          _suggestions = results;
          _isLoading = false;
        });
      }
    });
  }

  Future<void> _openMapPicker() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => MapLocationPicker(
          title: 'Pick ${widget.label}',
          // ✅ FIX: If user already selected a location, open map exactly there
          initialPosition: _selectedCoords ?? const LatLng(26.8467, 80.9462),
          useGpsIfNoInitial: _selectedCoords == null,
        ),
      ),
    );

    if (result != null && mounted) {
      final lat = result['lat'] as double;
      final lon = result['lon'] as double;
      final address = result['address'] as String;

      setState(() {
        widget.controller.text = address;
        _selectedCoords = LatLng(lat, lon);
        _suggestions = [];
        _locationConfirmed = true;
      });

      widget.onSelected(address, lat, lon);
    }
  }

  // ✅ NEW: Allow clearing the field
  void _clearField() {
    widget.controller.clear();
    setState(() {
      _selectedCoords = null;
      _suggestions = [];
      _locationConfirmed = false;
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: widget.controller,
          onChanged: _onSearchChanged,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontSize: 15,
          ),
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: widget.hint,
            prefixIcon: Icon(
              widget.icon,
              // ✅ Show green icon when location is confirmed
              color: _locationConfirmed ? AppColors.success : AppColors.primary,
            ),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                else if (widget.controller.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear, size: 20, color: Colors.grey),
                    onPressed: _clearField,
                  ),
                // ✅ Map picker button — always available
                IconButton(
                  icon: Icon(
                    Icons.map_outlined,
                    // ✅ Show confirmed color when pinned
                    color: _locationConfirmed ? AppColors.success : AppColors.primary,
                  ),
                  tooltip: 'Map pe select karein',
                  onPressed: _openMapPicker,
                ),
              ],
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              // ✅ Green border when confirmed
              borderSide: BorderSide(
                color: _locationConfirmed ? AppColors.success : Colors.grey.shade300,
                width: _locationConfirmed ? 1.5 : 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: _locationConfirmed ? AppColors.success : AppColors.primary,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: _locationConfirmed
                ? AppColors.success.withValues(alpha: 0.04)
                : Colors.grey[50],
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
        ),

        // ✅ Confirmed location indicator
        if (_locationConfirmed && _selectedCoords != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 12),
            child: Row(
              children: [
                const Icon(Icons.check_circle, size: 13, color: AppColors.success),
                const SizedBox(width: 4),
                Text(
                  'Location confirmed (${_selectedCoords!.latitude.toStringAsFixed(4)}, ${_selectedCoords!.longitude.toStringAsFixed(4)})',
                  style: const TextStyle(fontSize: 11, color: AppColors.success),
                ),
              ],
            ),
          ),

        // Suggestions dropdown
        if (_suggestions.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            constraints: const BoxConstraints(maxHeight: 250),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: _suggestions.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = _suggestions[index];
                return ListTile(
                  leading: const Icon(Icons.location_on_outlined, color: Colors.grey),
                  title: Text(
                    item['display_name'] as String,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14),
                  ),
                  onTap: () {
                    final lat = (item['lat'] as num).toDouble();
                    final lon = (item['lon'] as num).toDouble();
                    final name = item['display_name'] as String;

                    // ✅ FIX: Just set the coords and name — do NOT auto-open map picker
                    // User can manually open map picker if they want to refine
                    setState(() {
                      widget.controller.text = name;
                      _selectedCoords = LatLng(lat, lon);
                      _suggestions = [];
                      _locationConfirmed = true;
                    });

                    widget.onSelected(name, lat, lon);
                    FocusScope.of(context).unfocus();
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}
