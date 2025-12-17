import 'package:equatable/equatable.dart';

class UserSettings extends Equatable {
  final String userId;
  final bool isPushEnabled;
  final bool isEmailEnabled;
  final String currency;
  final String language;
  final bool isDarkMode;

  const UserSettings({
    required this.userId,
    this.isPushEnabled = true,
    this.isEmailEnabled = true,
    this.currency = 'USD',
    this.language = 'en',
    this.isDarkMode = false,
  });

  @override
  List<Object?> get props => [
        userId,
        isPushEnabled,
        isEmailEnabled,
        currency,
        language,
        isDarkMode,
      ];
}
