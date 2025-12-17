import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/initiate_payment_usecase.dart';
import '../../domain/usecases/verify_payment_usecase.dart';
import '../../domain/usecases/get_payment_status_usecase.dart';
import 'payment_event.dart';
import 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final InitiatePaymentUseCase initiatePaymentUseCase;
  final VerifyPaymentUseCase verifyPaymentUseCase;
  final GetPaymentStatusUseCase getPaymentStatusUseCase;

  PaymentBloc({
    required this.initiatePaymentUseCase,
    required this.verifyPaymentUseCase,
    required this.getPaymentStatusUseCase,
  }) : super(PaymentInitial()) {
    on<InitiatePaymentEvent>(_onInitiatePayment);
    on<VerifyPaymentEvent>(_onVerifyPayment);
    on<GetPaymentStatusEvent>(_onGetPaymentStatus);
  }

  Future<void> _onInitiatePayment(
    InitiatePaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());
    final result = await initiatePaymentUseCase(InitiatePaymentParams(
      bookingId: event.bookingId,
      amount: event.amount,
      currency: event.currency,
      method: event.method,
    ));
    result.fold(
      (failure) => emit(PaymentError(failure.message)),
      (payment) => emit(PaymentInitiated(payment)),
    );
  }

  Future<void> _onVerifyPayment(
    VerifyPaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());
    final result = await verifyPaymentUseCase(VerifyPaymentParams(
      paymentId: event.paymentId,
    ));
    result.fold(
      (failure) => emit(PaymentError(failure.message)),
      (payment) => emit(PaymentVerified(payment)),
    );
  }

  Future<void> _onGetPaymentStatus(
    GetPaymentStatusEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());
    final result = await getPaymentStatusUseCase(GetPaymentStatusParams(
      paymentId: event.paymentId,
    ));
    result.fold(
      (failure) => emit(PaymentError(failure.message)),
      (payment) => emit(PaymentStatusLoaded(payment)),
    );
  }
}
