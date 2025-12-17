import 'package:equatable/equatable.dart';

abstract class OwnerBookingEvent extends Equatable {
  const OwnerBookingEvent();

  @override
  List<Object> get props => [];
}

class GetOwnerBookingsEvent extends OwnerBookingEvent {
  final String ownerId;
  const GetOwnerBookingsEvent(this.ownerId);

  @override
  List<Object> get props => [ownerId];
}

class GetRevenueSummaryEvent extends OwnerBookingEvent {
  final String ownerId;
  final DateTime start;
  final DateTime end;
  
  const GetRevenueSummaryEvent({
    required this.ownerId, 
    required this.start, 
    required this.end
  });

  @override
  List<Object> get props => [ownerId, start, end];
}
