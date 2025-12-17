import '../../domain/entities/place_suggestion.dart';

class PlaceSuggestionModel extends PlaceSuggestion {
  const PlaceSuggestionModel({
    required super.placeId,
    required super.description,
    required super.mainText,
    required super.secondaryText,
  });

  factory PlaceSuggestionModel.fromJson(Map<String, dynamic> json) {
    // Adapter for Google Places Prediction
    return PlaceSuggestionModel(
      placeId: json['place_id'] as String,
      description: json['description'] as String,
      mainText: json['structured_formatting']?['main_text'] as String? ?? '',
      secondaryText: json['structured_formatting']?['secondary_text'] as String? ?? '',
    );
  }
}
