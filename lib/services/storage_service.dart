import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _rememberMeKey = 'remember_me';
  static const String _savedEmailKey = 'saved_email';
  static const String _savedPasswordKey = 'saved_password';
  
  static SharedPreferences? _prefs;
  
  // Initialize SharedPreferences
  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  // Get SharedPreferences instance
  static SharedPreferences get _preferences {
    if (_prefs == null) {
      throw Exception('StorageService not initialized. Call initialize() first.');
    }
    return _prefs!;
  }
  
  // Remember Me functionality
  static Future<void> setRememberMe(bool value) async {
    await _preferences.setBool(_rememberMeKey, value);
  }
  
  static bool getRememberMe() {
    return _preferences.getBool(_rememberMeKey) ?? false;
  }
  
  // Save login credentials
  static Future<void> saveCredentials(String email, String password) async {
    await _preferences.setString(_savedEmailKey, email);
    await _preferences.setString(_savedPasswordKey, password);
  }
  
  // Get saved credentials
  static Map<String, String?> getSavedCredentials() {
    return {
      'email': _preferences.getString(_savedEmailKey),
      'password': _preferences.getString(_savedPasswordKey),
    };
  }
  
  // Clear saved credentials
  static Future<void> clearCredentials() async {
    await _preferences.remove(_savedEmailKey);
    await _preferences.remove(_savedPasswordKey);
    await _preferences.remove(_rememberMeKey);
  }
  
  // Clear all stored data
  static Future<void> clearAll() async {
    await _preferences.clear();
  }
}