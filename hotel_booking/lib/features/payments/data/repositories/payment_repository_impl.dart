import 'package:fpdart/fpdart.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/payment_entity.dart';
import '../../domain/entities/payment_status.dart';
import '../../domain/repositories/payment_repository.dart';
import '../datasources/payment_remote_data_source.dart';
import '../models/payment_model.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;

  PaymentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, PaymentEntity>> initiatePayment({
    required String bookingId,
    required double amount,
    required String currency,
    required String method,
  }) async {
    try {
      final paymentModel = PaymentModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // Generate ID
        bookingId: bookingId,
        amount: amount,
        currency: currency,
        status: PaymentStatus.pending,
        method: method,
        timestamp: DateTime.now(),
      );
      final result = await remoteDataSource.initiatePayment(paymentModel);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaymentEntity>> verifyPayment(String paymentId) async {
    try {
      final result = await remoteDataSource.verifyPayment(paymentId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaymentEntity>> getPaymentStatus(String paymentId) async {
    try {
      final result = await remoteDataSource.getPaymentStatus(paymentId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
