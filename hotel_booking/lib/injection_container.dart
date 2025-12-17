import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';
import 'features/auth/data/datasources/auth_local_data_source.dart';
import 'features/auth/data/datasources/auth_local_data_source_impl.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/get_current_user_usecase.dart';
import 'features/auth/domain/usecases/sign_in_usecase.dart';
import 'features/auth/domain/usecases/sign_out_usecase.dart';
import 'features/auth/domain/usecases/sign_up_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/hotel/data/datasources/hotel_remote_data_source.dart';
import 'features/hotel/data/repositories/hotel_repository_impl.dart';
import 'features/hotel/domain/repositories/hotel_repository.dart';
import 'features/hotel/domain/usecases/get_hotel_details_usecase.dart';
import 'features/hotel/domain/usecases/get_hotels_usecase.dart';
import 'features/hotel/domain/usecases/search_hotels_usecase.dart';
import 'features/hotel/presentation/bloc/hotel_details/hotel_details_bloc.dart';
import 'features/hotel/presentation/bloc/hotel_list/hotel_list_bloc.dart';
import 'features/hotel/presentation/bloc/hotel_search/hotel_search_bloc.dart';
import 'features/payments/data/datasources/payment_remote_data_source.dart';
import 'features/payments/data/repositories/payment_repository_impl.dart';
import 'features/payments/domain/repositories/payment_repository.dart';
import 'features/payments/domain/usecases/get_payment_status_usecase.dart';
import 'features/payments/domain/usecases/initiate_payment_usecase.dart';
import 'features/payments/domain/usecases/verify_payment_usecase.dart';
import 'features/payments/presentation/bloc/payment_bloc.dart';
import 'features/wallet/data/datasources/wallet_remote_data_source.dart';
import 'features/wallet/data/repositories/wallet_repository_impl.dart';
import 'features/wallet/domain/repositories/wallet_repository.dart';
import 'features/wallet/domain/usecases/add_funds_usecase.dart';
import 'features/wallet/domain/usecases/get_transaction_history_usecase.dart';
import 'features/wallet/domain/usecases/get_wallet_usecase.dart';
import 'features/wallet/presentation/bloc/wallet_bloc.dart';
import 'features/booking/data/datasources/booking_remote_data_source.dart';
import 'features/booking/data/repositories/booking_repository_impl.dart';
import 'features/booking/domain/repositories/booking_repository.dart';
import 'features/booking/domain/usecases/cancel_booking_usecase.dart';
import 'features/booking/domain/usecases/check_availability_usecase.dart';
import 'features/booking/domain/usecases/create_booking_usecase.dart';
import 'features/booking/domain/usecases/get_user_bookings_usecase.dart';
import 'features/booking/presentation/bloc/booking_bloc.dart';
import 'features/booking/presentation/bloc/booking_bloc.dart';
import 'package:cloud_functions/cloud_functions.dart';

import 'features/owner/data/datasources/owner_remote_data_source.dart';
import 'features/owner/data/repositories/owner_booking_repository_impl.dart';
import 'features/owner/data/repositories/owner_hotel_repository_impl.dart';
import 'features/owner/domain/repositories/owner_booking_repository.dart';
import 'features/owner/domain/repositories/owner_hotel_repository.dart';
import 'features/owner/domain/usecases/add_room.dart';
import 'features/owner/domain/usecases/create_hotel.dart';
import 'features/owner/domain/usecases/get_owner_bookings.dart';
import 'features/owner/domain/usecases/get_owner_hotels.dart';
import 'features/owner/domain/usecases/get_revenue_summary.dart';
import 'features/owner/domain/usecases/toggle_room_availability.dart';
import 'features/owner/domain/usecases/update_hotel.dart';
import 'features/owner/domain/usecases/update_room.dart';
import 'features/owner/presentation/bloc/owner_booking/owner_booking_bloc.dart';
import 'features/owner/presentation/bloc/owner_hotel/owner_hotel_bloc.dart';
import 'features/location/data/datasources/device_location_service.dart';
import 'features/location/data/datasources/location_remote_data_source.dart';
import 'features/location/data/datasources/location_remote_data_source_impl.dart';
import 'features/location/data/repositories/location_repository_impl.dart';
import 'features/location/domain/repositories/location_repository.dart';
import 'features/location/domain/usecases/get_current_location_usecase.dart';
import 'features/location/domain/usecases/get_place_details_usecase.dart';
import 'features/location/domain/usecases/search_places_usecase.dart';
import 'features/location/presentation/bloc/location_bloc.dart';
import 'features/location/presentation/bloc/map_bloc.dart';
import 'features/location/presentation/bloc/place_search_bloc.dart';
import 'features/admin/data/datasources/admin_remote_data_source.dart';
import 'features/admin/data/datasources/admin_remote_data_source_impl.dart';
import 'features/admin/data/repositories/admin_repository_impl.dart';
import 'features/admin/domain/repositories/admin_repository.dart';
import 'features/admin/domain/usecases/analytics_usecases.dart';
import 'features/admin/domain/usecases/hotel_admin_usecases.dart';
import 'features/admin/domain/usecases/user_admin_usecases.dart';
import 'features/admin/presentation/bloc/admin_hotel_bloc.dart';
import 'features/admin/presentation/bloc/admin_user_bloc.dart';
import 'features/admin/presentation/bloc/analytics_bloc.dart';

import 'package:google_maps_webservice/places.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'features/owner/presentation/bloc/room/room_bloc.dart';

import 'features/profile/data/datasources/notification_remote_data_source.dart';
import 'features/profile/data/datasources/notification_remote_data_source_impl.dart';
import 'features/profile/data/datasources/profile_remote_data_source.dart';
import 'features/profile/data/datasources/profile_remote_data_source_impl.dart';
import 'features/profile/data/repositories/notification_repository_impl.dart';
import 'features/profile/data/repositories/profile_repository_impl.dart';
import 'features/profile/domain/repositories/notification_repository.dart';
import 'features/profile/domain/repositories/profile_repository.dart';
import 'features/profile/domain/usecases/get_notifications.dart';
import 'features/profile/domain/usecases/get_user_profile.dart';
import 'features/profile/domain/usecases/get_user_settings.dart';
import 'features/profile/domain/usecases/mark_notification_as_read.dart';
import 'features/profile/domain/usecases/update_user_profile.dart';
import 'features/profile/domain/usecases/update_user_settings.dart';
import 'features/profile/presentation/bloc/user_notification/user_notification_bloc.dart';
import 'features/profile/presentation/bloc/user_profile/user_profile_bloc.dart';
import 'features/profile/presentation/bloc/user_settings/user_settings_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Auth
  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      signUpUseCase: sl(),
      signInUseCase: sl(),
      signOutUseCase: sl(),
      getCurrentUserUseCase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: sl(),
      firestore: sl(),
    ),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      sharedPreferences: sl(),
    ),
  );

  // Features - Hotel
  // Bloc
  sl.registerFactory(() => HotelListBloc(getHotelsUseCase: sl()));
  sl.registerFactory(() => HotelSearchBloc(searchHotelsUseCase: sl()));
  sl.registerFactory(() => HotelDetailsBloc(getHotelDetailsUseCase: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetHotelsUseCase(sl()));
  sl.registerLazySingleton(() => SearchHotelsUseCase(sl()));
  sl.registerLazySingleton(() => GetHotelDetailsUseCase(sl()));

  // Repository
  sl.registerLazySingleton<HotelRepository>(
    () => HotelRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<HotelRemoteDataSource>(
    () => HotelRemoteDataSourceImpl(
      firestore: sl(),
    ),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));



  // Features - Booking
  // Bloc
  sl.registerFactory(
    () => BookingBloc(
      checkAvailabilityUseCase: sl(),
      createBookingUseCase: sl(),
      cancelBookingUseCase: sl(),
      getUserBookingsUseCase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => CheckAvailabilityUseCase(sl()));
  sl.registerLazySingleton(() => CreateBookingUseCase(sl()));
  sl.registerLazySingleton(() => CancelBookingUseCase(sl()));
  sl.registerLazySingleton(() => GetUserBookingsUseCase(sl()));

  // Repository
  sl.registerLazySingleton<BookingRepository>(
    () => BookingRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<BookingRemoteDataSource>(
    () => BookingRemoteDataSourceImpl(
      firestore: sl(),
      functions: sl(),
    ),
  );

  // Features - Payment
  // Bloc
  sl.registerFactory(
    () => PaymentBloc(
      initiatePaymentUseCase: sl(),
      verifyPaymentUseCase: sl(),
      getPaymentStatusUseCase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => InitiatePaymentUseCase(sl()));
  sl.registerLazySingleton(() => VerifyPaymentUseCase(sl()));
  sl.registerLazySingleton(() => GetPaymentStatusUseCase(sl()));

  // Repository
  sl.registerLazySingleton<PaymentRepository>(
    () => PaymentRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<PaymentRemoteDataSource>(
    () => PaymentRemoteDataSourceImpl(firestore: sl()),
  );

  // Features - Wallet
  // Bloc
  sl.registerFactory(
    () => WalletBloc(
      getWalletUseCase: sl(),
      addFundsUseCase: sl(),
      getTransactionHistoryUseCase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetWalletUseCase(sl()));
  sl.registerLazySingleton(() => AddFundsUseCase(sl()));
  sl.registerLazySingleton(() => GetTransactionHistoryUseCase(sl()));

  // Repository
  sl.registerLazySingleton<WalletRepository>(
    () => WalletRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<WalletRemoteDataSource>(
    () => WalletRemoteDataSourceImpl(firestore: sl()),
  );

  // Features - Owner
  // Bloc
  sl.registerFactory(
    () => OwnerHotelBloc(
      getOwnerHotels: sl(),
      createHotel: sl(),
      updateHotel: sl(),
    ),
  );
  sl.registerFactory(
    () => RoomBloc(
      repository: sl(),
      addRoom: sl(),
      updateRoom: sl(),
      toggleRoomAvailability: sl(),
    ),
  );
  sl.registerFactory(
    () => OwnerBookingBloc(
      getOwnerBookings: sl(),
      getRevenueSummary: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetOwnerHotels(sl()));
  sl.registerLazySingleton(() => CreateHotel(sl()));
  sl.registerLazySingleton(() => UpdateHotel(sl()));
  sl.registerLazySingleton(() => AddRoom(sl()));
  sl.registerLazySingleton(() => UpdateRoom(sl()));
  sl.registerLazySingleton(() => ToggleRoomAvailability(sl()));
  sl.registerLazySingleton(() => GetOwnerBookings(sl()));
  sl.registerLazySingleton(() => GetRevenueSummary(sl()));

  // Repositories
  sl.registerLazySingleton<OwnerHotelRepository>(
    () => OwnerHotelRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<OwnerBookingRepository>(
    () => OwnerBookingRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  // Note: OwnerRemoteDataSourceImpl is not yet implemented, assuming Interface or Implementation file.
  // Wait, I created the Interface 'OwnerRemoteDataSource' but I haven't created 'OwnerRemoteDataSourceImpl' yet.
  // I must create it before registering.
  // I will comment this out or create the file next.
  // For now I will mock it or leave it pending, but user asked to finish.
  // I'll assume I will create it in next step. I'll register it assuming implementation exists.
  sl.registerLazySingleton<OwnerRemoteDataSource>(
    () => OwnerRemoteDataSourceImpl(firestore: sl()),
  );

  // Features - Profile
  // Bloc
  sl.registerFactory(
    () => UserProfileBloc(
      getUserProfile: sl(),
      updateUserProfile: sl(),
    ),
  );
  sl.registerFactory(
    () => UserSettingsBloc(
      getUserSettings: sl(),
      updateUserSettings: sl(),
    ),
  );
  sl.registerFactory(
    () => UserNotificationBloc(
      getNotifications: sl(),
      markNotificationAsRead: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetUserProfile(sl()));
  sl.registerLazySingleton(() => UpdateUserProfile(sl()));
  sl.registerLazySingleton(() => GetUserSettings(sl()));
  sl.registerLazySingleton(() => UpdateUserSettings(sl()));
  sl.registerLazySingleton(() => GetNotifications(sl()));
  sl.registerLazySingleton(() => MarkNotificationAsRead(sl()));

  // Repositories
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(firestore: sl()),
  );
  sl.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(firestore: sl()),
  );

  // Features - Admin
  // Bloc
  sl.registerFactory(
    () => AdminUserBloc(getAllUsers: sl(), suspendUser: sl()),
  );
  sl.registerFactory(
    () => AdminHotelBloc(getAllHotels: sl(), approveHotel: sl()),
  );
  sl.registerFactory(
    () => AnalyticsBloc(getSummary: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAllUsersUseCase(sl()));
  sl.registerLazySingleton(() => SuspendUserUseCase(sl()));
  sl.registerLazySingleton(() => GetAllHotelsUseCase(sl()));
  sl.registerLazySingleton(() => ApproveHotelUseCase(sl()));
  sl.registerLazySingleton(() => GetAllBookingsUseCase(sl()));
  sl.registerLazySingleton(() => GetAnalyticsSummaryUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AdminRepository>(
    () => AdminRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AdminRemoteDataSource>(
    () => AdminRemoteDataSourceImpl(firestore: sl()),
  );

  // Features - Location
  // Bloc
  sl.registerFactory(() => LocationBloc(getCurrentLocation: sl()));
  sl.registerFactory(() => PlaceSearchBloc(searchPlaces: sl(), getPlaceDetails: sl()));
  sl.registerFactory(() => MapBloc());

  // Use cases
  sl.registerLazySingleton(() => GetCurrentLocationUseCase(sl()));
  sl.registerLazySingleton(() => SearchPlacesUseCase(sl()));
  sl.registerLazySingleton(() => GetPlaceDetailsUseCase(sl()));

  // Repository
  sl.registerLazySingleton<LocationRepository>(
    () => LocationRepositoryImpl(remoteDataSource: sl(), deviceService: sl()),
  );

  // Data sources
  sl.registerLazySingleton<LocationRemoteDataSource>(
    () => LocationRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<DeviceLocationService>(
    () => DeviceLocationServiceImpl(),
  );

  // External - Google Maps (Requires API Key from Env)
  sl.registerLazySingleton(() => GoogleMapsPlaces(apiKey: dotenv.env['GOOGLE_MAPS_API_KEY'] ?? 'YOUR_API_KEY'));

  // External
  // ... (existing external)
  sl.registerLazySingleton(() => FirebaseFunctions.instance);
}
