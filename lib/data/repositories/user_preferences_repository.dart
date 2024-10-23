import 'dart:convert';

import 'package:app/data/data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferencesRepository {
  // SharedPreferences instance
  late final SharedPreferences _prefs;

  UserPreferencesRepository(this._prefs);

  // Key names for user data
  static const String _userIdKey = 'user_id';
  static const String _usernameKey = 'username';
  static const String _emailKey = 'email';
  static const String _userDataKey = 'user_data';
  static const String userPassKey = 'user_pass';

  Future<void> saveUser(UserLoginModel user) async {
    final String userDataString = jsonEncode(user);

    await _prefs.setInt(_userIdKey, user.loggedUser.id);
    await _prefs.setString(_usernameKey, user.loggedUser.firstName);
    await _prefs.setString(_emailKey, user.loggedUser.email);
    await _prefs.setString(_userDataKey, userDataString);
  }

  Future<void> saveData(String key, String data) async {
    await _prefs.setString(key, data);
  }

  Future<String?> getStringData(String key) async {
    return _prefs.getString(key);
  }

  // Get user data
  Future<UserLoginModel?> getUser() async {
    // Get user data from SharedPreferences
    // final int? userId = _prefs.getInt(_userIdKey);
    // final String? username = _prefs.getString(_usernameKey);
    // final String? email = _prefs.getString(_emailKey);
    final String? userDataString = _prefs.getString(_userDataKey);

    if (userDataString == null) return null;

    // Convert JSON string to user data object
    final UserLoginModel user = userLoginModelFromJson(userDataString);
    return user;
  }

  Future removeUser() async {
    await _prefs.clear();
  }
}
