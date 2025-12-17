import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../bloc/analytics_bloc.dart';

class RevenueAnalyticsPage extends StatelessWidget {
  const RevenueAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AnalyticsBloc>()..add(LoadAnalytics()),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<AnalyticsBloc, AnalyticsState>(
          builder: (context, state) {
            if (state is AnalyticsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AnalyticsLoaded) {
              final summary = state.summary;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Revenue: \$${summary.totalRevenue.toStringAsFixed(2)}', style: Theme.of(context).textTheme.headlineMedium),
                  SizedBox(height: 10),
                  Text('Total Bookings: ${summary.totalBookings}'),
                  Text('Active Users: ${summary.activeUsers}'),
                  Text('Total Hotels: ${summary.totalHotels}'),
                  const SizedBox(height: 40),
                  const Text('Revenue Overview (Placeholder Chart)'),
                  SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: BarChart(
                      BarChartData(
                        barGroups: [
                           // Placeholder data since we only have total revenue in summary for now
                           BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: summary.totalRevenue, color: Colors.blue)])
                        ],
                        titlesData: FlTitlesData(show: false),
                        borderData: FlBorderData(show: false),
                      ),
                    ),
                  )
                ],
              );
            } else if (state is AnalyticsError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const Center(child: Text('Loading Analytics...'));
          },
        ),
      ),
    );
  }
}
