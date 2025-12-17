import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/admin_booking.dart';
import '../entities/analytics_summary.dart';
import '../repositories/admin_repository.dart';

class GetAllBookingsUseCase {
  final AdminRepository repository;
  GetAllBookingsUseCase(this.repository);
  Future<Either<Failure, List<AdminBooking>>> call() => repository.getAllBookings();
}

class GetAnalyticsSummaryUseCase {
  final AdminRepository repository;
  GetAnalyticsSummaryUseCase(this.repository);
  Future<Either<Failure, AnalyticsSummary>> call() => repository.getAnalyticsSummary();
}
