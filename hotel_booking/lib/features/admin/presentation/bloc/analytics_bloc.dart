import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/analytics_summary.dart';
import '../../domain/usecases/analytics_usecases.dart';

// Events
class LoadAnalytics extends Equatable {
  @override
  List<Object> get props => [];
}

// States
abstract class AnalyticsState extends Equatable {
  const AnalyticsState();
  @override
  List<Object> get props => [];
}

class AnalyticsInitial extends AnalyticsState {}
class AnalyticsLoading extends AnalyticsState {}
class AnalyticsLoaded extends AnalyticsState {
  final AnalyticsSummary summary;
  const AnalyticsLoaded(this.summary);
  @override
  List<Object> get props => [summary];
}
class AnalyticsError extends AnalyticsState {
  final String message;
  const AnalyticsError(this.message);
  @override
  List<Object> get props => [message];
}

// BLoC
class AnalyticsBloc extends Bloc<LoadAnalytics, AnalyticsState> {
  final GetAnalyticsSummaryUseCase getSummary;

  AnalyticsBloc({required this.getSummary}) : super(AnalyticsInitial()) {
    on<LoadAnalytics>((event, emit) async {
      emit(AnalyticsLoading());
      final result = await getSummary();
      result.fold(
        (failure) => emit(AnalyticsError(failure.message)),
        (summary) => emit(AnalyticsLoaded(summary)),
      );
    });
  }
}
