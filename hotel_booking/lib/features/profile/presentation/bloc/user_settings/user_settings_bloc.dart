import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_user_settings.dart';
import '../../domain/usecases/update_user_settings.dart';
import 'user_settings_event.dart';
import 'user_settings_state.dart';

class UserSettingsBloc extends Bloc<UserSettingsEvent, UserSettingsState> {
  final GetUserSettings getUserSettings;
  final UpdateUserSettings updateUserSettings;

  UserSettingsBloc({
    required this.getUserSettings,
    required this.updateUserSettings,
  }) : super(UserSettingsInitial()) {
    on<GetUserSettingsEvent>(_onGetUserSettings);
    on<UpdateUserSettingsEvent>(_onUpdateUserSettings);
  }

  Future<void> _onGetUserSettings(GetUserSettingsEvent event, Emitter<UserSettingsState> emit) async {
    emit(UserSettingsLoading());
    final result = await getUserSettings(event.userId);
    result.fold(
      (failure) => emit(UserSettingsError(failure.message)),
      (settings) => emit(UserSettingsLoaded(settings)),
    );
  }

  Future<void> _onUpdateUserSettings(UpdateUserSettingsEvent event, Emitter<UserSettingsState> emit) async {
    // Optimistic update could be handled here, but standard loading flow mainly:
    emit(UserSettingsLoading());
    final result = await updateUserSettings(event.settings);
    result.fold(
      (failure) => emit(UserSettingsError(failure.message)),
      (settings) {
        emit(UserSettingsUpdated(settings));
        emit(UserSettingsLoaded(settings));
      },
    );
  }
}
