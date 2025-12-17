import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/admin_user.dart';
import '../../domain/usecases/user_admin_usecases.dart';

// Events
abstract class AdminUserEvent extends Equatable {
  const AdminUserEvent();
  @override
  List<Object> get props => [];
}

class LoadAllUsers extends AdminUserEvent {}

class SuspendUserEvent extends AdminUserEvent {
  final String userId;
  final bool suspend; // True to suspend, false to unsuspend
  const SuspendUserEvent(this.userId, this.suspend);
  @override
  List<Object> get props => [userId, suspend];
}

// States
abstract class AdminUserState extends Equatable {
  const AdminUserState();
  @override
  List<Object> get props => [];
}

class AdminUserInitial extends AdminUserState {}
class AdminUserLoading extends AdminUserState {}
class AdminUserLoaded extends AdminUserState {
  final List<AdminUser> users;
  const AdminUserLoaded(this.users);
  @override
  List<Object> get props => [users];
}
class AdminUserError extends AdminUserState {
  final String message;
  const AdminUserError(this.message);
  @override
  List<Object> get props => [message];
}

// BLoC
class AdminUserBloc extends Bloc<AdminUserEvent, AdminUserState> {
  final GetAllUsersUseCase getAllUsers;
  final SuspendUserUseCase suspendUser;

  AdminUserBloc({required this.getAllUsers, required this.suspendUser}) : super(AdminUserInitial()) {
    on<LoadAllUsers>(_onLoadAllUsers);
    on<SuspendUserEvent>(_onSuspendUser);
  }

  Future<void> _onLoadAllUsers(LoadAllUsers event, Emitter<AdminUserState> emit) async {
    emit(AdminUserLoading());
    final result = await getAllUsers();
    result.fold(
      (failure) => emit(AdminUserError(failure.message)),
      (users) => emit(AdminUserLoaded(users)),
    );
  }

  Future<void> _onSuspendUser(SuspendUserEvent event, Emitter<AdminUserState> emit) async {
    // Optimistic or refresh? Let's refresh for safety.
    final result = await suspendUser(event.userId, event.suspend);
    result.fold(
      (failure) => emit(AdminUserError(failure.message)),
      (_) => add(LoadAllUsers()),
    );
  }
}
