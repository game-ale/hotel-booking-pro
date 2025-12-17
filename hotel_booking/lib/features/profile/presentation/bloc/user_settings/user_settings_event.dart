import 'package:equatable/equatable.dart';
import '../../domain/entities/user_settings.dart';

abstract class UserSettingsEvent extends Equatable {
  const UserSettingsEvent();
  
  @override
  List<Object?> get props => [];
}

class GetUserSettingsEvent extends UserSettingsEvent {
  final String userId;
  const GetUserSettingsEvent(this.userId);
  @override
  List<Object?> get props => [userId];
}

class UpdateUserSettingsEvent extends UserSettingsEvent {
  final UserSettings settings;
  const UpdateUserSettingsEvent(this.settings);
  @override
  List<Object?> get props => [settings];
}
