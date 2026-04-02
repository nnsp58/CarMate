import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group('Waypoints Search Logic Verification', () {
    // 15km threshold as defined in RideService
    const double distanceThreshold = 15000.0;
    const distance = Distance();

    // Lucknow to Delhi Route Points (Simplified representation of NH 91 / GT Road)
    final lkoToDelhiRoute = <LatLng>[
      const LatLng(26.8467, 80.9462), // Lucknow (Start)
      const LatLng(27.0500, 79.9167), // Kannauj
      const LatLng(27.2333, 79.0167), // Mainpuri
      const LatLng(27.5667, 78.6667), // Etah
      const LatLng(27.6000, 78.0500), // Hathras
      const LatLng(27.8833, 78.0833), // Aligarh
      const LatLng(28.4070, 77.8444), // Bulandshahr
      const LatLng(28.6692, 77.4538), // Ghaziabad
      const LatLng(28.6139, 77.2090), // Delhi (End)
    ];

    bool isMatch(LatLng searchFrom, LatLng searchTo, List<LatLng> ridePoints) {
      int startIndex = -1;
      double minStartDist = double.infinity;

      // Find if any point on ride is near search 'from'
      for (int i = 0; i < ridePoints.length; i++) {
        final d = distance.as(LengthUnit.Meter, searchFrom, ridePoints[i]);
        if (d < distanceThreshold && d < minStartDist) {
          minStartDist = d;
          startIndex = i;
        }
      }

      if (startIndex == -1) return false;

      // Find if any point AFTER startIndex is near search 'to'
      int endIndex = -1;
      double minEndDist = double.infinity;
      for (int i = startIndex; i < ridePoints.length; i++) {
        final d = distance.as(LengthUnit.Meter, searchTo, ridePoints[i]);
        if (d < distanceThreshold && d < minEndDist) {
          minEndDist = d;
          endIndex = i;
        }
      }

      return endIndex != -1;
    }

    test('Full route search (Lucknow to Delhi) matches', () {
      const searchFrom = LatLng(26.8467, 80.9462); // Lucknow
      const searchTo = LatLng(28.6139, 77.2090); // Delhi
      expect(isMatch(searchFrom, searchTo, lkoToDelhiRoute), isTrue);
    });

    test('Intermediate point search (Aligarh to Delhi) matches', () {
      const searchFrom = LatLng(27.8833, 78.0833); // Aligarh
      const searchTo = LatLng(28.6139, 77.2090); // Delhi
      expect(isMatch(searchFrom, searchTo, lkoToDelhiRoute), isTrue);
    });

    test('Subset search (Kannauj to Aligarh) matches', () {
      const searchFrom = LatLng(27.0500, 79.9167); // Kannauj
      const searchTo = LatLng(27.8833, 78.0833); // Aligarh
      expect(isMatch(searchFrom, searchTo, lkoToDelhiRoute), isTrue);
    });

    test('Reverse search (Delhi to Aligarh) fails for One-Way ride', () {
      const searchFrom = LatLng(28.6139, 77.2090); // Delhi
      const searchTo = LatLng(27.8833, 78.0833); // Aligarh
      expect(isMatch(searchFrom, searchTo, lkoToDelhiRoute), isFalse);
    });

    test('Search near Bulandshahr matches if within 15km threshold', () {
      // 28.4070, 77.8444 is Bulandshahr. Let's try 10km away.
      const searchFrom = LatLng(28.4070, 77.9444); // ~10km east of Bulandshahr
      const searchTo = LatLng(28.6139, 77.2090); // Delhi
      expect(isMatch(searchFrom, searchTo, lkoToDelhiRoute), isTrue);
    });

    test('Search far away from route fails', () {
      const searchFrom = LatLng(25.3176, 82.9739); // Varanasi (Far from route)
      const searchTo = LatLng(28.6139, 77.2090); // Delhi
      expect(isMatch(searchFrom, searchTo, lkoToDelhiRoute), isFalse);
    });
  });
}
