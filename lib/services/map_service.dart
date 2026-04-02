import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class MapService {
  static final Map<String, String> _cityCache = {};

  // Helper: City-level results ko priority do
  static int _locationPriority(Map<String, dynamic> item) {
    final type = (item['type'] ?? '').toString().toLowerCase();
    if (type == 'city') return 0;
    if (type == 'town') return 1;
    if (type == 'village') return 2;
    if (type == 'suburb') return 3;
    if (type == 'district') return 4;
    return 5;
  }

  // Photon API for Autocomplete (Free, No key) — biased towards India
  static Future<List<Map<String, dynamic>>> searchPlaces(String query) async {
    if (query.length < 3) return [];

    // ✅ FIX: Special mapping for Bulandshahr as requested by user
    if (query.toLowerCase().trim() == 'bulandshahr' || query.toLowerCase().trim() == 'bulandshahar') {
      return [
        {
          'display_name': 'Bulandshahr, Bulandshahr, Bus Stand Roadways, India, PIN 203001',
          'lat': 28.4045, // Exact coordinates for Main Roadways Bus Stand 
          'lon': 77.8550,
          'type': 'bus_station' // Very priority
        }
      ];
    }
    
    try {
      // Photon with India location bias (lat=22, lon=78 = center of India)
      final response = await http.get(
        Uri.parse('https://photon.komoot.io/api/?q=${Uri.encodeComponent(query)}&limit=5&lat=22&lon=78&lang=en'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List features = data['features'];
        
        if (features.isNotEmpty) {
          final results = features.map((f) {
            final props = f['properties'];
            final coords = f['geometry']['coordinates'];
            
            String name = props['name'] ?? '';
            String city = props['city'] ?? props['town'] ?? '';
            String state = props['state'] ?? '';
            String country = props['country'] ?? '';
            
            String description = [city, state, country]
                .where((s) => s.isNotEmpty && s != name)
                .join(', ');

            return {
              'display_name': name + (description.isNotEmpty ? ', $description' : ''),
              'lat': (coords[1] as num).toDouble(),
              'lon': (coords[0] as num).toDouble(),
              'type': props['osm_value'] ?? 'location',
            };
          }).toList();

          results.sort((a, b) => 
            _locationPriority(a).compareTo(_locationPriority(b)));
          return results;
        }
      }

      // Fallback: Nominatim search if Photon returns empty
      return await _searchNominatim(query);
    } catch (e) {
      debugPrint('Search error: $e');
      // Try Nominatim as fallback
      try {
        return await _searchNominatim(query);
      } catch (_) {}
    }
    return [];
  }

  // Nominatim fallback search (for when Photon doesn't find results)
  static Future<List<Map<String, dynamic>>> _searchNominatim(String query) async {
    final response = await http.get(
      Uri.parse(
        'https://nominatim.openstreetmap.org/search'
        '?q=${Uri.encodeComponent(query)}'
        '&format=json&limit=8&countrycodes=in'
        '&featuretype=city,town,village'
        '&addressdetails=1',
      ),
      headers: {'User-Agent': 'RideOn_App'},
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      final results = data.map((item) {
        final type = item['type'] ?? item['class'] ?? '';
        return {
          'display_name': item['display_name'] as String,
          'lat': double.parse(item['lat']),
          'lon': double.parse(item['lon']),
          'type': type,
        };
      }).toList();
      
      // City/town pehle dikhao
      results.sort((a, b) => 
        _locationPriority(a).compareTo(_locationPriority(b)));
      return results;
    }
    return [];
  }

  // OSRM API for Routing — returns multiple route alternatives
  static Future<List<RouteOption>> getDetailedRoutes(LatLng start, LatLng end) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=full&geometries=geojson&alternatives=3&radiuses=1000;1000',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List routes = data['routes'];
        
        // Fetch all route options with descriptive names in parallel
        final List<RouteOption> options = [];
        
        for (int i = 0; i < routes.length; i++) {
          final r = routes[i];
          final List coords = r['geometry']['coordinates'];
          
          // FORCE START AND END COORDINATES TO BE THE USER'S PIN
          // Prepending 'start' and appending 'end' ensures visual connection
          final List<LatLng> points = coords
              .map((c) => LatLng(c[1].toDouble(), c[0].toDouble()))
              .toList();
          final String summary = r['legs']?[0]?['summary'] ?? '';
          
          // --- Smart Naming Logic ---
          String displayName = summary.isNotEmpty ? summary : 'Route ${i + 1}';
          String? category;

          // Detect common Indian road types
          final lowerSummary = summary.toLowerCase();
          if (lowerSummary.contains('expressway') || lowerSummary.contains('yamuna')) {
            category = 'Expressway';
          } else if (lowerSummary.contains('ah') || lowerSummary.contains('nh') || lowerSummary.contains('highway')) {
            category = 'National Highway';
          } else if (lowerSummary.contains('gt road') || lowerSummary.contains('grand trunk')) {
            category = 'GT Road';
          }

          // Fetch major cities along the route to show "Via City1, City2..."
          List<String> viaCities = [];
          if (points.length > 20) {
            const segments = 4;
            for (int j = 1; j <= segments; j++) {
              final idx = (j * points.length) ~/ (segments + 1);
              // Sequential await to avoid rate limiting
              final city = await getCityFromLatLng(points[idx].latitude, points[idx].longitude);
              if (city != 'Unknown' && !viaCities.contains(city)) {
                viaCities.add(city);
              }
            }
          }
          
          String viaText = viaCities.isNotEmpty ? ' (Via ${viaCities.join(', ')})' : '';

          // Construct final descriptive name
          if (category != null) {
            displayName = '$category$viaText';
          } else if (summary.isNotEmpty) {
            displayName = '$summary$viaText';
          } else if (viaText.isNotEmpty) {
            displayName = 'Via ${viaText.replaceAll(' (Via ', '').replaceAll(')', '')}';
          }

          options.add(RouteOption(
            points: points,
            distanceKm: (r['distance'] as num) / 1000,
            durationMins: (r['duration'] as num) ~/ 60,
            name: displayName,
          ));
        }
        return options;
      }
    } catch (e) {
      debugPrint('Routing error: $e');
    }
    return [];
  }

  // Simplified geocoding to get just the City/Town name
  static Future<String> getCityFromLatLng(double lat, double lon) async {
    // Round to 3 decimal places to match cities in cache (approx 100m precision)
    final cacheKey = '${lat.toStringAsFixed(3)},${lon.toStringAsFixed(3)}';
    if (_cityCache.containsKey(cacheKey)) return _cityCache[cacheKey]!;

    try {
      final response = await http.get(
        Uri.parse('https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lon&zoom=10'),
        headers: {'User-Agent': 'RideOn_App_v2'},
      ).timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final address = data['address'];
        final city = address['city'] ?? address['town'] ?? address['county'] ?? address['district'] ?? 'Unknown';
        if (city != 'Unknown') _cityCache[cacheKey] = city;
        return city;
      }
    } catch (_) {}
    return 'Unknown';
  }

  // Legacy support for single route points
  static Future<List<LatLng>> getRoute(LatLng start, LatLng end) async {
    final routes = await getDetailedRoutes(start, end);
    return routes.isNotEmpty ? routes[0].points : [];
  }

  // Nominatim for Reverse Geocoding
  static Future<String> getAddressFromLatLng(double lat, double lon) async {
    try {
      final response = await http.get(
        Uri.parse('https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lon'),
        headers: {'User-Agent': 'RideOn_App'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['display_name'] ?? 'Unknown Location';
      }
    } catch (e) {
      debugPrint('Geocoding error: $e');
    }
    return 'Unknown Location';
  }
}

class RouteOption {
  final List<LatLng> points;
  final double distanceKm;
  final int durationMins;
  final String name;

  RouteOption({
    required this.points,
    required this.distanceKm,
    required this.durationMins,
    required this.name,
  });
}
