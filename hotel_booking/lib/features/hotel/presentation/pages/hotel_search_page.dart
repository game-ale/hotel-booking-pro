import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/search_filter_entity.dart';
import '../bloc/hotel_search/hotel_search_bloc.dart';
import '../bloc/hotel_search/hotel_search_event.dart';
import '../bloc/hotel_search/hotel_search_state.dart';
import '../widgets/hotel_card.dart';

class HotelSearchPage extends StatefulWidget {
  const HotelSearchPage({super.key});

  @override
  State<HotelSearchPage> createState() => _HotelSearchPageState();
}

class _HotelSearchPageState extends State<HotelSearchPage> {
  final _searchController = TextEditingController();
  double? _minPrice;
  double? _maxPrice;
  double? _minRating;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    final filter = SearchFilterEntity(
      query: _searchController.text,
      minPrice: _minPrice,
      maxPrice: _maxPrice,
      minRating: _minRating,
    );
    context.read<HotelSearchBloc>().add(SearchHotels(filter));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Hotels'),
      ),
      body: Column(
        children: [
          // Search Form
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: 'Search by name or location',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Min Price',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) =>
                            _minPrice = double.tryParse(value),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Max Price',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) =>
                            _maxPrice = double.tryParse(value),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Min Rating (0-5)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => _minRating = double.tryParse(value),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _performSearch,
                  child: const Text('Search'),
                ),
              ],
            ),
          ),
          // Search Results
          Expanded(
            child: BlocBuilder<HotelSearchBloc, HotelSearchState>(
              builder: (context, state) {
                if (state is HotelSearchLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is HotelSearchFailure) {
                  return Center(child: Text(state.message));
                } else if (state is HotelSearchLoaded) {
                  if (state.hotels.isEmpty) {
                    return const Center(child: Text('No hotels found'));
                  }
                  return ListView.builder(
                    itemCount: state.hotels.length,
                    itemBuilder: (context, index) {
                      final hotel = state.hotels[index];
                      return HotelCard(
                        hotel: hotel,
                        onTap: () => context.push('/hotel-details/${hotel.id}'),
                      );
                    },
                  );
                }
                return const Center(
                  child: Text('Enter search criteria above'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
