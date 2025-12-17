import 'package:equatable/equatable.dart';
import '../../domain/entities/user_profile.dart';

abstract class UserProfileEvent extends Equatable {
  const UserProfileEvent();

  @override
  List<Object?> get props => [];
}

class GetUserProfileEvent extends UserProfileEvent {
  final String userId;

  const GetUserProfileEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class UpdateUserProfileEvent extends UserProfileEvent {
  final UserProfile profile;

  const UpdateUserProfileEvent(this.profile);

  @override
  List<Object?> get props => [profile];
}
