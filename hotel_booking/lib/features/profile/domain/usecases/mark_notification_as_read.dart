import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../repositories/notification_repository.dart';

class MarkNotificationAsRead {
  final NotificationRepository repository;

  MarkNotificationAsRead(this.repository);

  Future<Either<Failure, void>> call(String userId, String notificationId) async {
    return await repository.markAsRead(userId, notificationId);
  }
}
