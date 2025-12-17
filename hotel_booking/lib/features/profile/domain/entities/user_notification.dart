import 'package:equatable/equatable.dart';

enum NotificationType { booking, payment, system, promotion }

class UserNotification extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String body;
  final DateTime timestamp;
  final bool isRead;
  final NotificationType type;
  final String? relatedEntityId; // e.g., BookingID or PaymentID

  const UserNotification({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.timestamp,
    this.isRead = false,
    required this.type,
    this.relatedEntityId,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        body,
        timestamp,
        isRead,
        type,
        relatedEntityId,
      ];
}
