import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_wallet_usecase.dart';
import '../../domain/usecases/add_funds_usecase.dart';
import '../../domain/usecases/get_transaction_history_usecase.dart';
import 'wallet_event.dart';
import 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final GetWalletUseCase getWalletUseCase;
  final AddFundsUseCase addFundsUseCase;
  final GetTransactionHistoryUseCase getTransactionHistoryUseCase;

  WalletBloc({
    required this.getWalletUseCase,
    required this.addFundsUseCase,
    required this.getTransactionHistoryUseCase,
  }) : super(WalletInitial()) {
    on<GetWalletEvent>(_onGetWallet);
    on<AddFundsEvent>(_onAddFunds);
    on<GetTransactionHistoryEvent>(_onGetTransactionHistory);
  }

  Future<void> _onGetWallet(
    GetWalletEvent event,
    Emitter<WalletState> emit,
  ) async {
    emit(WalletLoading());
    final result = await getWalletUseCase(GetWalletParams(userId: event.userId));
    result.fold(
      (failure) => emit(WalletError(failure.message)),
      (wallet) => emit(WalletLoaded(wallet)),
    );
  }

  Future<void> _onAddFunds(
    AddFundsEvent event,
    Emitter<WalletState> emit,
  ) async {
    emit(WalletLoading());
    final result = await addFundsUseCase(AddFundsParams(
      userId: event.userId,
      amount: event.amount,
      currency: event.currency,
      paymentMethodId: event.paymentMethodId,
    ));
    result.fold(
      (failure) => emit(WalletError(failure.message)),
      (wallet) => emit(WalletFundsAdded(wallet)),
    );
  }

  Future<void> _onGetTransactionHistory(
    GetTransactionHistoryEvent event,
    Emitter<WalletState> emit,
  ) async {
    emit(WalletLoading());
    final result = await getTransactionHistoryUseCase(GetTransactionHistoryParams(
      userId: event.userId,
    ));
    result.fold(
      (failure) => emit(WalletError(failure.message)),
      (transactions) => emit(TransactionHistoryLoaded(transactions)),
    );
  }
}
