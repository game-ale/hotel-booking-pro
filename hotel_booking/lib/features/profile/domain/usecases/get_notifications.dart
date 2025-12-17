import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_notification.dart';
import '../repositories/notification_repository.dart';

class GetNotifications {
  final NotificationRepository repository;

  GetNotifications(this.repository);

  Stream<Either<Failure, List<UserNotification>>> call(String userId) {
    return repository.getNotifications(userId);
  }
}
