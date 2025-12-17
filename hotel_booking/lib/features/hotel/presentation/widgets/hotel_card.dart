import 'package:flutter/material.dart';
import '../../domain/entities/hotel_entity.dart';

class HotelCard extends StatelessWidget {
  final HotelEntity hotel;
  final VoidCallback onTap;

  const HotelCard({
    super.key,
    required this.hotel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hotel Image
            hotel.images.isNotEmpty
                ? Image.network(
                    hotel.images.first,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 180,
                        color: Colors.grey[300],
                        child: const Icon(Icons.hotel, size: 64),
                      );
                    },
                  )
                : Container(
                    height: 180,
                    color: Colors.grey[300],
                    child: const Icon(Icons.hotel, size: 64),
                  ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hotel Name
                  Text(
                    hotel.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Location
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        hotel.location,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Rating
                  Row(
                    children: [
                      ...List.generate(5, (index) {
                        return Icon(
                          index < hotel.rating.floor()
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 20,
                        );
                      }),
                      const SizedBox(width: 8),
                      Text('${hotel.rating.toStringAsFixed(1)}'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Price
                  Text(
                    '\$${hotel.pricePerNight.toStringAsFixed(0)} / night',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
