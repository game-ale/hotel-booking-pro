import 'package:equatable/equatable.dart';

class AnalyticsSummary extends Equatable {
  final double totalRevenue;
  final int totalBookings;
  final int activeUsers;
  final int totalHotels;
  
  // Could add specific data points for charts later
  // e.g., Map<DateTime, double> revenueOverTime;

  const AnalyticsSummary({
    required this.totalRevenue,
    required this.totalBookings,
    required this.activeUsers,
    required this.totalHotels,
  });

  @override
  List<Object?> get props => [totalRevenue, totalBookings, activeUsers, totalHotels];
}
