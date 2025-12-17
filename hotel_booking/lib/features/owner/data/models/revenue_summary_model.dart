import '../../domain/entities/revenue_summary.dart';

class RevenueSummaryModel extends RevenueSummary {
  const RevenueSummaryModel({
    required super.totalRevenue,
    required super.totalBookings,
    required super.periodStart,
    required super.periodEnd,
  });

  factory RevenueSummaryModel.fromJson(Map<String, dynamic> json) {
    return RevenueSummaryModel(
      totalRevenue: (json['totalRevenue'] as num).toDouble(),
      totalBookings: json['totalBookings'] as int,
      periodStart: DateTime.parse(json['periodStart'] as String),
      periodEnd: DateTime.parse(json['periodEnd'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalRevenue': totalRevenue,
      'totalBookings': totalBookings,
      'periodStart': periodStart.toIso8601String(),
      'periodEnd': periodEnd.toIso8601String(),
    };
  }
}
