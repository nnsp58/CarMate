import 'package:supabase_flutter/supabase_flutter.dart';

class ReviewService {
  static final _supabase = Supabase.instance.client;

  /// Submits a rating and optional comment for a completed ride.
  /// Creates a record in the `reviews` table.
  static Future<void> submitReview({
    required String rideId,
    required String bookingId,
    required String revieweeId,
    required int rating,
    String? comment,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    // Insert review into Supabase `reviews` table
    await _supabase.from('reviews').upsert({
      'ride_id': rideId,
      'booking_id': bookingId,
      'reviewer_id': userId,
      'reviewee_id': revieweeId,
      'rating': rating,
      'comment': comment,
      'created_at': DateTime.now().toIso8601String(),
    });

    // Optionally update the ride's average rating
    // You can do this via a Supabase database function/trigger, or call a separate RPC:
    // await _supabase.rpc('update_ride_rating', params: {'p_ride_id': rideId});
  }
}
