import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalStorage {
  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyUser = 'user';
  static const String _keyOnboardingCompleted = 'onboarding_completed';
  static const String _keyDarkMode = 'dark_mode';
  static const String _keyNotificationEnabled = 'notification_enabled';
  static const String _keyLanguage = 'language';
  static const String _keyAutoPlayVideo = 'auto_play_video';

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Token
  Future<void> setAccessToken(String token) async {
    await _prefs.setString(_keyAccessToken, token);
  }

  String? getAccessToken() {
    return _prefs.getString(_keyAccessToken);
  }

  Future<void> setRefreshToken(String token) async {
    await _prefs.setString(_keyRefreshToken, token);
  }

  String? getRefreshToken() {
    return _prefs.getString(_keyRefreshToken);
  }

  Future<void> clearTokens() async {
    await _prefs.remove(_keyAccessToken);
    await _prefs.remove(_keyRefreshToken);
  }

  // User
  Future<void> setUser(Map<String, dynamic> user) async {
    await _prefs.setString(_keyUser, jsonEncode(user));
  }

  Map<String, dynamic>? getUser() {
    final userString = _prefs.getString(_keyUser);
    if (userString == null) return null;
    return jsonDecode(userString) as Map<String, dynamic>;
  }

  Future<void> clearUser() async {
    await _prefs.remove(_keyUser);
  }

  // Onboarding
  Future<void> setOnboardingCompleted(bool completed) async {
    await _prefs.setBool(_keyOnboardingCompleted, completed);
  }

  bool isOnboardingCompleted() {
    return _prefs.getBool(_keyOnboardingCompleted) ?? false;
  }

  // Settings
  Future<void> setDarkMode(bool enabled) async {
    await _prefs.setBool(_keyDarkMode, enabled);
  }

  bool isDarkMode() {
    return _prefs.getBool(_keyDarkMode) ?? false;
  }

  Future<void> setNotificationEnabled(bool enabled) async {
    await _prefs.setBool(_keyNotificationEnabled, enabled);
  }

  bool isNotificationEnabled() {
    return _prefs.getBool(_keyNotificationEnabled) ?? true;
  }

  Future<void> setLanguage(String language) async {
    await _prefs.setString(_keyLanguage, language);
  }

  String getLanguage() {
    return _prefs.getString(_keyLanguage) ?? 'ko';
  }

  Future<void> setAutoPlayVideo(bool enabled) async {
    await _prefs.setBool(_keyAutoPlayVideo, enabled);
  }

  bool isAutoPlayVideo() {
    return _prefs.getBool(_keyAutoPlayVideo) ?? true;
  }

  // Clear all
  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
