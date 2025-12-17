import '../models/owner_hotel_model.dart';
import '../models/room_model.dart';
import '../models/owner_booking_model.dart';
import '../models/revenue_summary_model.dart';

abstract class OwnerRemoteDataSource {
  Future<List<OwnerHotelModel>> getOwnerHotels(String ownerId);
  Future<OwnerHotelModel> createHotel(OwnerHotelModel hotel);
  Future<OwnerHotelModel> updateHotel(OwnerHotelModel hotel);
  Future<List<RoomModel>> getRooms(String hotelId);
  Future<RoomModel> addRoom(RoomModel room);
  Future<RoomModel> updateRoom(RoomModel room);
  Future<RoomModel> toggleRoomAvailability(String roomId, bool isAvailable);
  Future<List<OwnerBookingModel>> getOwnerBookings(String ownerId);
  Future<RevenueSummaryModel> getRevenueSummary(String ownerId, DateTime start, DateTime end);
}
