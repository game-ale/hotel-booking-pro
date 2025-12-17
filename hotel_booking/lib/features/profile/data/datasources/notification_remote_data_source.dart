import '../models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Stream<List<NotificationModel>> getNotifications(String userId);
  Future<void> markAsRead(String userId, String notificationId);
}
