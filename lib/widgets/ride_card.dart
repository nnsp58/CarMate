import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/ride_model.dart';
import '../core/constants/app_colors.dart';

class RideCard extends StatelessWidget {
  final RideModel ride;
  final VoidCallback onTap;

  const RideCard({
    super.key,
    required this.ride,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEE, MMM d • hh:mm a');

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: InkWell(
        onTap: ride.isInPast ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: Opacity(
          opacity: ride.isInPast ? 0.6 : 1.0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Top Section: Driver Info & Price
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: (ride.driverPhotoUrl != null && ride.driverPhotoUrl!.isNotEmpty)
                        ? CachedNetworkImageProvider(ride.driverPhotoUrl!)
                        : null,
                    child: (ride.driverPhotoUrl == null || ride.driverPhotoUrl!.isEmpty)
                        ? const Icon(Icons.person)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ride.driverName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star, size: 16, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(
                              ride.driverRating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      ride.formattedPrice,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Divider(),
              ),
              // Route Section
              Row(
                children: [
                  Column(
                    children: [
                      const Icon(Icons.circle_outlined,
                          size: 20, color: AppColors.primary),
                      Container(
                        width: 2,
                        height: 30,
                        color: Colors.grey[300],
                      ),
                      const Icon(Icons.location_on,
                          size: 20, color: AppColors.secondary),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ride.fromLocation,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          ride.toLocation,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Bottom Section: Time & Seats
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.access_time,
                          size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 8),
                      Text(
                        dateFormat.format(ride.departureDatetime),
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      if (ride.distanceKm != null) ...[
                        const SizedBox(width: 12),
                        const Icon(Icons.straighten,
                            size: 16, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          '${ride.distanceKm!.toStringAsFixed(1)} km',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        ride.isInPast ? Icons.event_busy : Icons.airline_seat_recline_normal,
                        size: 16, 
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        ride.isInPast 
                            ? 'DEPARTED'
                            : ride.availableSeats == 0 
                                ? 'FULL' 
                                : '${ride.availableSeats} seats left',
                        style: TextStyle(
                          color: ride.isInPast 
                              ? AppColors.error
                              : ride.availableSeats == 0 
                                  ? AppColors.error 
                                  : (ride.availableSeats < 2 ? AppColors.error : AppColors.textSecondary),
                          fontSize: 14,
                          fontWeight: (ride.availableSeats < 2 || ride.isInPast)
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}
