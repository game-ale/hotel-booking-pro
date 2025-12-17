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
import 'package:cloud_functions/cloud_functions.dart';

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

  // External
  // ... (existing external)
  sl.registerLazySingleton(() => FirebaseFunctions.instance);
}
