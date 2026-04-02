import '../models/booking_model.dart';
import 'supabase_service.dart';

class BookingService {
  /// Book a ride seat
  static Future<Map<String, dynamic>> bookRide({
    required String rideId,
    required String passengerId,
    required String passengerName,
    String? passengerPhone,
    String? fromLocation,
    String? toLocation,
    double? fromLat,
    double? fromLng,
    double? toLat,
    double? toLng,
    required int seatsBooked,
    required double totalPrice,
  }) async {
    try {
      final response = await SupabaseService.client.rpc('book_ride_seat', params: {
        'p_ride_id': rideId,
        'p_passenger_id': passengerId,
        'p_passenger_name': passengerName,
        'p_passenger_phone': passengerPhone,
        'p_from_location': fromLocation,
        'p_to_location': toLocation,
        'p_from_lat': fromLat,
        'p_from_lng': fromLng,
        'p_to_lat': toLat,
        'p_to_lng': toLng,
        'p_seats_booked': seatsBooked,
        'p_total_price': totalPrice,
      });

      return response;
    } catch (e) {
      if (e.toString().contains('PostgrestException')) {
        // Extract message from Supabase error if possible
        throw Exception(e.toString().split('message: ').last.split(',').first);
      }
      throw Exception('$e');
    }
  }

  /// Cancel booking
  static Future<Map<String, dynamic>> cancelBooking({
    required String bookingId,
    required String userId,
    String? reason,
  }) async {
    try {
      final response = await SupabaseService.client.rpc('cancel_booking', params: {
        'p_booking_id': bookingId,
        'p_user_id': userId,
        'p_reason': reason,
      });

      return response;
    } catch (e) {
      throw Exception('Failed to cancel booking: $e');
    }
  }

  /// Get user's bookings with ride details
  static Future<List<BookingModel>> getMyBookings({
    required String passengerId,
  }) async {
    try {
      final response = await SupabaseService.client
          .from('bookings')
          .select('*, rides(from_location, to_location, departure_datetime), users!passenger_id(bio, photo_url, email)')
          .eq('passenger_id', passengerId)
          .order('booked_at', ascending: false);

      return (response as List).map((json) {
        final ride = json['rides'];
        final passenger = json['users'];
        return BookingModel.fromJson(json).copyWith(
          rideFrom: ride?['from_location'],
          rideTo: ride?['to_location'],
          departureDatetime: ride != null ? DateTime.parse(ride['departure_datetime']) : null,
          passengerBio: passenger?['bio'],
          passengerPhotoUrl: passenger?['photo_url'],
          passengerEmail: passenger?['email'],
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to get my bookings: $e');
    }
  }

  static Future<List<BookingModel>> getBookingsForRide({
    required String rideId,
  }) async {
    try {
      final response = await SupabaseService.client
          .from('bookings')
          .select('*, rides(from_location, to_location, departure_datetime), users!passenger_id(bio, photo_url, email)')
          .eq('ride_id', rideId)
          .order('booked_at', ascending: false);

      return (response as List).map((json) {
        final ride = json['rides'];
        final passenger = json['users'];
        return BookingModel.fromJson(json).copyWith(
          rideFrom: ride?['from_location'],
          rideTo: ride?['to_location'],
          departureDatetime: ride != null ? DateTime.parse(ride['departure_datetime']) : null,
          passengerBio: passenger?['bio'],
          passengerPhotoUrl: passenger?['photo_url'],
          passengerEmail: passenger?['email'],
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to get ride bookings: $e');
    }
  }

  /// Update booking status
  static Future<void> updateBookingStatus({
    required String bookingId,
    required String status,
    String? cancelReason,
  }) async {
    try {
      final updates = {'status': status};
      if (cancelReason != null) {
        updates['cancel_reason'] = cancelReason;
        updates['cancelled_at'] = DateTime.now().toIso8601String();
      }

      await SupabaseService.client
          .from('bookings')
          .update(updates)
          .eq('id', bookingId);
    } catch (e) {
      throw Exception('Failed to update booking: $e');
    }
  }

  static Future<BookingModel?> getBookingById({
    required String bookingId,
  }) async {
    try {
      final response = await SupabaseService.client
          .from('bookings')
          .select('*, rides(from_location, to_location, departure_datetime), users!passenger_id(bio, photo_url, email)')
          .eq('id', bookingId)
          .maybeSingle();

      if (response == null) return null;
      
      final ride = response['rides'];
      final passenger = response['users'];
      return BookingModel.fromJson(response).copyWith(
        rideFrom: ride?['from_location'],
        rideTo: ride?['to_location'],
        departureDatetime: ride != null ? DateTime.parse(ride['departure_datetime']) : null,
        passengerBio: passenger?['bio'],
        passengerPhotoUrl: passenger?['photo_url'],
        passengerEmail: passenger?['email'],
      );
    } catch (e) {
      throw Exception('Failed to get booking: $e');
    }
  }
}
