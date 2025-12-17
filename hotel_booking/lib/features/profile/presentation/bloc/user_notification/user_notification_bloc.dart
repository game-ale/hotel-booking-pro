import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_notification.dart';
import '../../domain/usecases/get_notifications.dart';
import '../../domain/usecases/mark_notification_as_read.dart';
import 'user_notification_event.dart';
import 'user_notification_state.dart';

class UserNotificationBloc extends Bloc<UserNotificationEvent, UserNotificationState> {
  final GetNotifications getNotifications;
  final MarkNotificationAsRead markNotificationAsRead;
  StreamSubscription? _subscription;

  UserNotificationBloc({
    required this.getNotifications,
    required this.markNotificationAsRead,
  }) : super(NotificationInitial()) {
    on<StartNotificationStream>(_onStartStream);
    on<MarkAsReadEvent>(_onMarkAsRead);
    on<_NotificationsUpdatedEvent>(_onNotificationsUpdated);
    on<_NotificationErrorEvent>(_onNotificationError);
  }

  Future<void> _onStartStream(StartNotificationStream event, Emitter<UserNotificationState> emit) async {
    emit(NotificationLoading());
    await _subscription?.cancel();
    _subscription = getNotifications(event.userId).listen(
      (result) {
        result.fold(
          (failure) => add(_NotificationErrorEvent(failure.message)),
          (notifications) => add(_NotificationsUpdatedEvent(notifications)),
        );
      },
      onError: (e) {
         add(_NotificationErrorEvent(e.toString()));
      }
    );
  }

  Future<void> _onMarkAsRead(MarkAsReadEvent event, Emitter<UserNotificationState> emit) async {
    final result = await markNotificationAsRead(event.userId, event.notificationId);
    result.fold(
      (failure) => add(_NotificationErrorEvent(failure.message)),
      (_) {},
    );
  }

  void _onNotificationsUpdated(_NotificationsUpdatedEvent event, Emitter<UserNotificationState> emit) {
    emit(NotificationsLoaded(event.notifications));
  }

  void _onNotificationError(_NotificationErrorEvent event, Emitter<UserNotificationState> emit) {
    emit(NotificationError(event.message));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}

class _NotificationsUpdatedEvent extends UserNotificationEvent {
  final List<UserNotification> notifications;
   const _NotificationsUpdatedEvent(this.notifications);
   @override
   List<Object?> get props => [notifications];
}

class _NotificationErrorEvent extends UserNotificationEvent {
  final String message;
  const _NotificationErrorEvent(this.message);
  @override
   List<Object?> get props => [message];
}
