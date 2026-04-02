import 'package:flutter_test/flutter_test.dart';
import 'package:rideon/models/ride_model.dart';
import 'package:rideon/services/ride_service.dart';

void main() {
  group('RideService.calculateRideSegment', () {
    final mockRide = RideModel(
      id: '1',
      driverId: 'd1',
      driverName: 'Driver',
      fromLocation: 'City A',
      toLocation: 'City D',
      fromLat: 10.0,
      fromLng: 10.0,
      toLat: 40.0,
      toLng: 40.0,
      departureDatetime: DateTime.now(),
      createdAt: DateTime.now(),
      totalSeats: 4,
      availableSeats: 4,
      pricePerSeat: 400.0,
      distanceKm: 400.0,
      durationMins: 400,
      routePointsJson: [
        {'lat': 20.0, 'lng': 20.0},
        {'lat': 30.0, 'lng': 30.0},
      ],
    );

    test('matches exact start and end points', () {
      final result = RideService.calculateRideSegment(
        ride: mockRide,
        searchFromLat: 10.0,
        searchFromLng: 10.0,
        searchToLat: 40.0,
        searchToLng: 40.0,
      );

      expect(result, isNotNull);
      expect(result!.segmentPrice, closeTo(400.0, 1.0));
    });

    test('matches intermediate points (pro-rata pricing)', () {
      final result = RideService.calculateRideSegment(
        ride: mockRide,
        searchFromLat: 20.0,
        searchFromLng: 20.0,
        searchToLat: 30.0,
        searchToLng: 30.0,
      );

      expect(result, isNotNull);
      // Segment is roughly half the distance (20,20 to 30,30)
      // Actual should be around 141km vs 424km full distance? 
      // The price should be significantly less than 400
      expect(result!.segmentPrice, lessThan(400.0));
      expect(result.segmentPrice, greaterThan(30.0));
    });

    test('returns null if points are too far', () {
      final result = RideService.calculateRideSegment(
        ride: mockRide,
        searchFromLat: 90.0,
        searchFromLng: 90.0,
        searchToLat: 0.0,
        searchToLng: 0.0,
      );

      expect(result, isNull);
    });
  });
}
