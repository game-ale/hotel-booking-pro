import 'package:equatable/equatable.dart';
import '../../../domain/entities/search_filter_entity.dart';

abstract class HotelSearchEvent extends Equatable {
  const HotelSearchEvent();

  @override
  List<Object> get props => [];
}

class SearchHotels extends HotelSearchEvent {
  final SearchFilterEntity filter;

  const SearchHotels(this.filter);

  @override
  List<Object> get props => [filter];
}

class ClearSearch extends HotelSearchEvent {}
