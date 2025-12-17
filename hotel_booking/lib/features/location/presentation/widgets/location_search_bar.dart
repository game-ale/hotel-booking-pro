import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/place_search_bloc.dart';

class LocationSearchBar extends StatelessWidget {
  final Function(String placeId) onPlaceSelected;

  const LocationSearchBar({super.key, required this.onPlaceSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: const InputDecoration(
            hintText: 'Search for a city or hotel',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
          onChanged: (value) {
            context.read<PlaceSearchBloc>().add(SearchQueryChanged(value));
          },
        ),
        BlocBuilder<PlaceSearchBloc, PlaceSearchState>(
          builder: (context, state) {
            if (state is PlaceSearchLoading) {
               return const LinearProgressIndicator();
            } else if (state is PlaceSearchLoaded) {
               final suggestions = state.suggestions;
               if (suggestions.isEmpty) return const SizedBox.shrink();
               
               return Container(
                 color: Colors.white,
                 constraints: const BoxConstraints(maxHeight: 200),
                 child: ListView.separated(
                   itemCount: suggestions.length,
                   separatorBuilder: (_, __) => const Divider(height: 1),
                   itemBuilder: (context, index) {
                     final item = suggestions[index];
                     return ListTile(
                       title: Text(item.mainText),
                       subtitle: Text(item.secondaryText),
                       onTap: () {
                         onPlaceSelected(item.placeId);
                         context.read<PlaceSearchBloc>().add(ClearSearch());
                         // Clear text field? Or keep it? keeping it is complex via stateless.
                         // For MVP, trigger selection.
                       },
                     );
                   },
                 ),
               );
            } else if (state is PlaceSearchError) {
              return Text('Error: ${state.message}', style: const TextStyle(color: Colors.red));
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
