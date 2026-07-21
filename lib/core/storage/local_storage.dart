import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String _tokenKey = 'jwt_token';
  static const String _userKey = 'user_data';
  static const String _rolesKey = 'user_roles';

  final SharedPreferences _prefs;

  LocalStorage(this._prefs);

  Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  String? getToken() {
    return _prefs.getString(_tokenKey);
  }

  Future<void> saveUser(String userStr) async {
    await _prefs.setString(_userKey, userStr);
  }

  String? getUser() {
    return _prefs.getString(_userKey);
  }

  Future<void> saveRoles(List<String> roles) async {
    await _prefs.setStringList(_rolesKey, roles);
  }

  List<String>? getRoles() {
    return _prefs.getStringList(_rolesKey);
  }

  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
