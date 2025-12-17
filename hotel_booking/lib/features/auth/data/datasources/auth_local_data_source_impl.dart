import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../datasources/auth_local_data_source.dart';
import '../models/user_model.dart';

const CACHED_USER = 'CACHED_USER';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheUser(UserModel user) {
    return sharedPreferences.setString(
      CACHED_USER,
      json.encode(user.toJson()),
    );
  }

  @override
  Future<UserModel?> getLastUser() {
    final jsonString = sharedPreferences.getString(CACHED_USER);
    if (jsonString != null) {
      return Future.value(UserModel.fromJson(json.decode(jsonString)));
    } else {
      return Future.value(null);
    }
  }

  @override
  Future<void> clearCache() {
    return sharedPreferences.remove(CACHED_USER);
  }
}
