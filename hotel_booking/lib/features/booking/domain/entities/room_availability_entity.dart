import 'package:equatable/equatable.dart';

class RoomAvailabilityEntity extends Equatable {
  final String roomId;
  final bool isAvailable;
  final double price;

  const RoomAvailabilityEntity({
    required this.roomId,
    required this.isAvailable,
    required this.price,
  });

  @override
  List<Object> get props => [roomId, isAvailable, price];
}
