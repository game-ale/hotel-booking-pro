import '../../domain/entities/user_settings.dart';

class UserSettingsModel extends UserSettings {
  const UserSettingsModel({
    required super.userId,
    super.isPushEnabled,
    super.isEmailEnabled,
    super.currency,
    super.language,
    super.isDarkMode,
  });

  factory UserSettingsModel.fromJson(Map<String, dynamic> json) {
    return UserSettingsModel(
      userId: json['userId'] as String,
      isPushEnabled: json['isPushEnabled'] as bool? ?? true,
      isEmailEnabled: json['isEmailEnabled'] as bool? ?? true,
      currency: json['currency'] as String? ?? 'USD',
      language: json['language'] as String? ?? 'en',
      isDarkMode: json['isDarkMode'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'isPushEnabled': isPushEnabled,
      'isEmailEnabled': isEmailEnabled,
      'currency': currency,
      'language': language,
      'isDarkMode': isDarkMode,
    };
  }

  factory UserSettingsModel.fromEntity(UserSettings entity) {
    return UserSettingsModel(
      userId: entity.userId,
      isPushEnabled: entity.isPushEnabled,
      isEmailEnabled: entity.isEmailEnabled,
      currency: entity.currency,
      language: entity.language,
      isDarkMode: entity.isDarkMode,
    );
  }
}
