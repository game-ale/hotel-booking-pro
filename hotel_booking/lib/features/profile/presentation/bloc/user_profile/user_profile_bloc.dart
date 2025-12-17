import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_user_profile.dart';
import '../../domain/usecases/update_user_profile.dart';
import 'user_profile_event.dart';
import 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final GetUserProfile getUserProfile;
  final UpdateUserProfile updateUserProfile;

  UserProfileBloc({
    required this.getUserProfile,
    required this.updateUserProfile,
  }) : super(UserProfileInitial()) {
    on<GetUserProfileEvent>(_onGetUserProfile);
    on<UpdateUserProfileEvent>(_onUpdateUserProfile);
  }

  Future<void> _onGetUserProfile(
    GetUserProfileEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(UserProfileLoading());
    final result = await getUserProfile(event.userId);
    result.fold(
      (failure) => emit(UserProfileError(failure.message)),
      (profile) => emit(UserProfileLoaded(profile)),
    );
  }

  Future<void> _onUpdateUserProfile(
    UpdateUserProfileEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(UserProfileLoading());
    final result = await updateUserProfile(event.profile);
    result.fold(
      (failure) => emit(UserProfileError(failure.message)),
      (profile) {
        emit(UserProfileUpdated(profile));
        // Optionally revert to Loaded state if needed, but Updated serves similar purpose
        emit(UserProfileLoaded(profile)); 
      },
    );
  }
}
