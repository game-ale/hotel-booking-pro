import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/revenue_summary.dart';
import '../repositories/owner_booking_repository.dart';

class GetRevenueSummaryParams {
  final String ownerId;
  final DateTime start;
  final DateTime end;

  GetRevenueSummaryParams({required this.ownerId, required this.start, required this.end});
}

class GetRevenueSummary {
  final OwnerBookingRepository repository;

  GetRevenueSummary(this.repository);

  Future<Either<Failure, RevenueSummary>> call(GetRevenueSummaryParams params) async {
    return await repository.getRevenueSummary(params.ownerId, params.start, params.end);
  }
}
