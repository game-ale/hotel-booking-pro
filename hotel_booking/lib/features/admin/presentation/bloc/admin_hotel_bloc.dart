import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/admin_hotel.dart';
import '../../domain/usecases/hotel_admin_usecases.dart';

// Events
abstract class AdminHotelEvent extends Equatable {
  const AdminHotelEvent();
  @override
  List<Object> get props => [];
}

class LoadAllHotels extends AdminHotelEvent {
  final bool? pendingOnly;
  const LoadAllHotels({this.pendingOnly});
  @override
  List<Object> get props => [pendingOnly ?? false];
}

class ApproveHotelEvent extends AdminHotelEvent {
  final String hotelId;
  final bool approve;
  const ApproveHotelEvent(this.hotelId, this.approve);
  @override
  List<Object> get props => [hotelId, approve];
}

// States
abstract class AdminHotelState extends Equatable {
  const AdminHotelState();
  @override
  List<Object> get props => [];
}

class AdminHotelInitial extends AdminHotelState {}
class AdminHotelLoading extends AdminHotelState {}
class AdminHotelLoaded extends AdminHotelState {
  final List<AdminHotel> hotels;
  const AdminHotelLoaded(this.hotels);
  @override
  List<Object> get props => [hotels];
}
class AdminHotelError extends AdminHotelState {
  final String message;
  const AdminHotelError(this.message);
  @override
  List<Object> get props => [message];
}

// BLoC
class AdminHotelBloc extends Bloc<AdminHotelEvent, AdminHotelState> {
  final GetAllHotelsUseCase getAllHotels;
  final ApproveHotelUseCase approveHotel;

  AdminHotelBloc({required this.getAllHotels, required this.approveHotel}) : super(AdminHotelInitial()) {
    on<LoadAllHotels>(_onLoadAllHotels);
    on<ApproveHotelEvent>(_onApproveHotel);
  }

  Future<void> _onLoadAllHotels(LoadAllHotels event, Emitter<AdminHotelState> emit) async {
    emit(AdminHotelLoading());
    final result = await getAllHotels(pendingOnly: event.pendingOnly);
    result.fold(
      (failure) => emit(AdminHotelError(failure.message)),
      (hotels) => emit(AdminHotelLoaded(hotels)),
    );
  }

  Future<void> _onApproveHotel(ApproveHotelEvent event, Emitter<AdminHotelState> emit) async {
    final result = await approveHotel(event.hotelId, event.approve);
    result.fold(
      (failure) => emit(AdminHotelError(failure.message)),
      (_) => add(const LoadAllHotels(pendingOnly: true)), // Refresh pending, or previous filter
    );
  }
}
