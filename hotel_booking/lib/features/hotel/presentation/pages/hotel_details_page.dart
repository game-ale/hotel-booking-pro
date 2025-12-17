import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/hotel_details/hotel_details_bloc.dart';
import '../bloc/hotel_details/hotel_details_event.dart';
import '../bloc/hotel_details/hotel_details_state.dart';

class HotelDetailsPage extends StatelessWidget {
  final String hotelId;

  const HotelDetailsPage({
    super.key,
    required this.hotelId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HotelDetailsBloc, HotelDetailsState>(
        builder: (context, state) {
          if (state is HotelDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HotelDetailsFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  ElevatedButton(
                    onPressed: () => context
                        .read<HotelDetailsBloc>()
                        .add(LoadHotelDetails(hotelId)),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is HotelDetailsLoaded) {
            final hotel = state.hotel;
            return CustomScrollView(
              slivers: [
                // App Bar with Image
                SliverAppBar(
                  expandedHeight: 300,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(hotel.name),
                    background: hotel.images.isNotEmpty
                        ? PageView.builder(
                            itemCount: hotel.images.length,
                            itemBuilder: (context, index) {
                              return Image.network(
                                hotel.images[index],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.hotel, size: 64),
                                  );
                                },
                              );
                            },
                          )
                        : Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.hotel, size: 64),
                          ),
                  ),
                ),
                // Hotel Details
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Location
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(
                              hotel.location,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Rating
                        Row(
                          children: [
                            ...List.generate(5, (index) {
                              return Icon(
                                index < hotel.rating.floor()
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.amber,
                                size: 24,
                              );
                            }),
                            const SizedBox(width: 8),
                            Text(
                              '${hotel.rating.toStringAsFixed(1)} / 5',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Price
                        Text(
                          '\$${hotel.pricePerNight.toStringAsFixed(0)} / night',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Description
                        const Text(
                          'About',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          hotel.description,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 24),
                        // Amenities
                        const Text(
                          'Amenities',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: hotel.amenities.map((amenity) {
                            return Chip(
                              label: Text(amenity),
                              avatar: const Icon(Icons.check_circle, size: 18),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
                        // Book Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              context.push(
                                '/booking/${hotel.id}/${hotel.id}_room1/${hotel.pricePerNight}',
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(16),
                            ),
                            child: const Text(
                              'Book Now',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
