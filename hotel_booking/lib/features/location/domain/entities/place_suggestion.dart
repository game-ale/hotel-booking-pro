import 'package:equatable/equatable.dart';

class PlaceSuggestion extends Equatable {
  final String placeId;
  final String description; // Full text
  final String mainText; // e.g. "Hotel California"
  final String secondaryText; // e.g. "Los Angeles, CA"

  const PlaceSuggestion({
    required this.placeId,
    required this.description,
    required this.mainText,
    required this.secondaryText,
  });

  @override
  List<Object?> get props => [placeId, description, mainText, secondaryText];
}
