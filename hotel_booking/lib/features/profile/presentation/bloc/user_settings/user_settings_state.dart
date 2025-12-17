import 'package:equatable/equatable.dart';
import '../../domain/entities/user_settings.dart';

abstract class UserSettingsState extends Equatable {
  const UserSettingsState();

  @override
  List<Object?> get props => [];
}

class UserSettingsInitial extends UserSettingsState {}
class UserSettingsLoading extends UserSettingsState {}
class UserSettingsLoaded extends UserSettingsState {
  final UserSettings settings;
  const UserSettingsLoaded(this.settings);
  @override
  List<Object?> get props => [settings];
}
class UserSettingsUpdated extends UserSettingsState {
   final UserSettings settings;
   const UserSettingsUpdated(this.settings);
   @override
   List<Object?> get props => [settings];
}
class UserSettingsError extends UserSettingsState {
  final String message;
  const UserSettingsError(this.message);
  @override
  List<Object?> get props => [message];
}
