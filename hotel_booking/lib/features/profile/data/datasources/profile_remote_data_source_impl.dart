import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_profile_model.dart';
import '../models/user_settings_model.dart';
import 'profile_remote_data_source.dart';

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseFirestore firestore;

  ProfileRemoteDataSourceImpl({required this.firestore});

  @override
  Future<UserProfileModel> getUserProfile(String userId) async {
    try {
      final doc = await firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserProfileModel.fromJson(doc.data()!);
      } else {
        throw ServerException('User profile not found');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserProfileModel> updateUserProfile(UserProfileModel profile) async {
    try {
      await firestore.collection('users').doc(profile.id).update(profile.toJson());
      return profile;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserSettingsModel> getUserSettings(String userId) async {
    try {
      final doc = await firestore
          .collection('users')
          .doc(userId)
          .collection('settings')
          .doc('general')
          .get();

      if (doc.exists) {
        return UserSettingsModel.fromJson(doc.data()!);
      } else {
        // Return default settings if none exist
        return UserSettingsModel(userId: userId);
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserSettingsModel> updateUserSettings(UserSettingsModel settings) async {
    try {
      await firestore
          .collection('users')
          .doc(settings.userId)
          .collection('settings')
          .doc('general')
          .set(settings.toJson()); // Use set to create if not exists
      return settings;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
