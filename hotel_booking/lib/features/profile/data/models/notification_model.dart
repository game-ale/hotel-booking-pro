import '../../domain/entities/user_notification.dart';

class NotificationModel extends UserNotification {
  const NotificationModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.body,
    required super.timestamp,
    super.isRead,
    required super.type,
    super.relatedEntityId,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isRead: json['isRead'] as bool? ?? false,
      type: NotificationType.values.firstWhere(
        (e) => e.toString() == 'NotificationType.${json['type']}',
        orElse: () => NotificationType.system,
      ),
      relatedEntityId: json['relatedEntityId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'body': body,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'type': type.toString().split('.').last,
      'relatedEntityId': relatedEntityId,
    };
  }

  factory NotificationModel.fromEntity(UserNotification entity) {
    return NotificationModel(
      id: entity.id,
      userId: entity.userId,
      title: entity.title,
      body: entity.body,
      timestamp: entity.timestamp,
      isRead: entity.isRead,
      type: entity.type,
      relatedEntityId: entity.relatedEntityId,
    );
  }
}
