import 'package:equatable/equatable.dart';
import '../../domain/entities/user_notification.dart';

abstract class UserNotificationState extends Equatable {
  const UserNotificationState();
  @override
  List<Object?> get props => [];
}

class NotificationInitial extends UserNotificationState {}
class NotificationLoading extends UserNotificationState {}
class NotificationsLoaded extends UserNotificationState {
  final List<UserNotification> notifications;
  const NotificationsLoaded(this.notifications);
  @override
  List<Object?> get props => [notifications];
}
class NotificationError extends UserNotificationState {
  final String message;
  const NotificationError(this.message);
  @override
  List<Object?> get props => [message];
}
