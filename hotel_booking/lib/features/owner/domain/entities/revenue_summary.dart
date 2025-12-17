import 'package:equatable/equatable.dart';

class RevenueSummary extends Equatable {
  final double totalRevenue;
  final int totalBookings;
  final DateTime periodStart;
  final DateTime periodEnd;

  const RevenueSummary({
    required this.totalRevenue,
    required this.totalBookings,
    required this.periodStart,
    required this.periodEnd,
  });

  @override
  List<Object?> get props => [
        totalRevenue,
        totalBookings,
        periodStart,
        periodEnd,
      ];
}
