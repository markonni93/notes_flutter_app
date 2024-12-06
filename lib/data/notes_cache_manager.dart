import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../auth/repository/model/user.dart';

abstract class NotesCacheManager {
  Future<void> insertUser(NoteUser user);

  Future<NoteUser?> getUser();

  Future<void> removeUser();
}

final class NotesCacheManagerImpl implements NotesCacheManager {
  final SharedPreferencesAsync _asyncPrefs = SharedPreferencesAsync();
  final _userKey = "user_key";

  @override
  Future<void> insertUser(NoteUser user) async {
    final String userJson = jsonEncode(user.toJson());
    await _asyncPrefs.setString(_userKey, userJson);
  }

  @override
  Future<NoteUser?> getUser() async {
    final String? userJson = await _asyncPrefs.getString(_userKey);

    if (userJson == null) {
      return NoteUser.empty;
    }

    final Map<String, dynamic> userMap = jsonDecode(userJson);
    final NoteUser user = NoteUser.fromJson(userMap);
    return user;
  }

  Future<void> removeUserFromPreferences() async {
    await _asyncPrefs.remove(_userKey);
  }

  @override
  Future<void> removeUser() async {
    _asyncPrefs.remove(_userKey);
  }
}