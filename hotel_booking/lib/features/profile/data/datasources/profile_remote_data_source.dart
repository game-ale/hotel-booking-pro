import '../models/user_profile_model.dart';
import '../models/user_settings_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserProfileModel> getUserProfile(String userId);
  Future<UserProfileModel> updateUserProfile(UserProfileModel profile);
  Future<UserSettingsModel> getUserSettings(String userId);
  Future<UserSettingsModel> updateUserSettings(UserSettingsModel settings);
}
