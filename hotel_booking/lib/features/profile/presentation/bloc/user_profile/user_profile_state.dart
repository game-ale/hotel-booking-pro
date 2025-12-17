import 'package:equatable/equatable.dart';
import '../../domain/entities/user_profile.dart';

abstract class UserProfileState extends Equatable {
  const UserProfileState();

  @override
  List<Object?> get props => [];
}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class UserProfileLoaded extends UserProfileState {
  final UserProfile profile;

  const UserProfileLoaded(this.profile);

  @override
  List<Object?> get props => [profile];
}

// Emitted momentarily after update
class UserProfileUpdated extends UserProfileState {
  final UserProfile profile;

  const UserProfileUpdated(this.profile);

  @override
  List<Object?> get props => [profile];
}

class UserProfileError extends UserProfileState {
  final String message;

  const UserProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
