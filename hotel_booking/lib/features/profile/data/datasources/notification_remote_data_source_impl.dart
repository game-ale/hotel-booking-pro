import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/error/exceptions.dart';
import '../models/notification_model.dart';
import 'notification_remote_data_source.dart';

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final FirebaseFirestore firestore;

  NotificationRemoteDataSourceImpl({required this.firestore});

  @override
  Stream<List<NotificationModel>> getNotifications(String userId) {
    // Assuming notifications are stored in users/{userId}/notifications
    // Or a top-level collection 'notifications' with userId field.
    // Plan said: users/{userId}/notifications
    return firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => NotificationModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    });
  }

  @override
  Future<void> markAsRead(String userId, String notificationId) async {
    try {
      await firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .doc(notificationId)
          .update({'isRead': true});
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
