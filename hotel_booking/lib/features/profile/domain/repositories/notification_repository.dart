import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_notification.dart';

abstract class NotificationRepository {
  Stream<Either<Failure, List<UserNotification>>> getNotifications(String userId);
  Future<Either<Failure, void>> markAsRead(String userId, String notificationId);
}
