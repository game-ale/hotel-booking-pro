import 'package:equatable/equatable.dart';

abstract class UserNotificationEvent extends Equatable {
  const UserNotificationEvent();
  @override
  List<Object?> get props => [];
}

class StartNotificationStream extends UserNotificationEvent {
  final String userId;
  const StartNotificationStream(this.userId);
  @override
  List<Object?> get props => [userId];
}

class MarkAsReadEvent extends UserNotificationEvent {
  final String userId;
  final String notificationId;
  const MarkAsReadEvent(this.userId, this.notificationId);
  @override
  List<Object?> get props => [userId, notificationId];
}
