// lib/services/storage_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static SharedPreferences? _prefs;

  // Initialize storage
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Get SharedPreferences instance
  static SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception(
          'StorageService not initialized. Call StorageService.init() first.');
    }
    return _prefs!;
  }

  // Save string value
  static Future<bool> saveString(String key, String value) async {
    return await prefs.setString(key, value);
  }

  // Get string value
  static String? getString(String key) {
    return prefs.getString(key);
  }

  // Save integer value
  static Future<bool> saveInt(String key, int value) async {
    return await prefs.setInt(key, value);
  }

  // Get integer value
  static int? getInt(String key) {
    return prefs.getInt(key);
  }

  // Save double value
  static Future<bool> saveDouble(String key, double value) async {
    return await prefs.setDouble(key, value);
  }

  // Get double value
  static double? getDouble(String key) {
    return prefs.getDouble(key);
  }

  // Save boolean value
  static Future<bool> saveBool(String key, bool value) async {
    return await prefs.setBool(key, value);
  }

  // Get boolean value
  static bool? getBool(String key) {
    return prefs.getBool(key);
  }

  // Save list of strings
  static Future<bool> saveStringList(String key, List<String> value) async {
    return await prefs.setStringList(key, value);
  }

  // Get list of strings
  static List<String>? getStringList(String key) {
    return prefs.getStringList(key);
  }

  // Save object as JSON
  static Future<bool> saveObject(
      String key, Map<String, dynamic> object) async {
    final jsonString = jsonEncode(object);
    return await saveString(key, jsonString);
  }

  // Get object from JSON
  static Map<String, dynamic>? getObject(String key) {
    final jsonString = getString(key);
    if (jsonString != null) {
      try {
        return jsonDecode(jsonString) as Map<String, dynamic>;
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // Save list of objects as JSON
  static Future<bool> saveObjectList(
      String key, List<Map<String, dynamic>> objects) async {
    final jsonString = jsonEncode(objects);
    return await saveString(key, jsonString);
  }

  // Get list of objects from JSON
  static List<Map<String, dynamic>>? getObjectList(String key) {
    final jsonString = getString(key);
    if (jsonString != null) {
      try {
        final List<dynamic> decoded = jsonDecode(jsonString);
        return decoded.cast<Map<String, dynamic>>();
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // Remove value by key
  static Future<bool> remove(String key) async {
    return await prefs.remove(key);
  }

  // Check if key exists
  static bool containsKey(String key) {
    return prefs.containsKey(key);
  }

  // Clear all data
  static Future<bool> clear() async {
    return await prefs.clear();
  }

  // Get all keys
  static Set<String> getAllKeys() {
    return prefs.getKeys();
  }

  // Storage keys constants
  static const String keyAuthToken = 'auth_token';
  static const String keyUserData = 'user_data';
  static const String keyThemeMode = 'theme_mode';
  static const String keyLanguage = 'language';
  static const String keyOnboardingCompleted = 'onboarding_completed';
  static const String keyFavoriteAttractions = 'favorite_attractions';
  static const String keyFavoriteAccommodations = 'favorite_accommodations';
  static const String keySearchHistory = 'search_history';
  static const String keyRecentlyViewed = 'recently_viewed';
  static const String keyOfflineData = 'offline_data';
  static const String keyLastSyncTime = 'last_sync_time';
  static const String keyNotificationSettings = 'notification_settings';
  static const String keyLocationPermissionAsked = 'location_permission_asked';

  // Helper methods for common operations

  // Theme methods
  static Future<bool> saveThemeMode(String mode) async {
    return await saveString(keyThemeMode, mode);
  }

  static String getThemeMode() {
    return getString(keyThemeMode) ?? 'system';
  }

  // Language methods
  static Future<bool> saveLanguage(String language) async {
    return await saveString(keyLanguage, language);
  }

  static String getLanguage() {
    return getString(keyLanguage) ?? 'en';
  }

  // Onboarding methods
  static Future<bool> setOnboardingCompleted() async {
    return await saveBool(keyOnboardingCompleted, true);
  }

  static bool isOnboardingCompleted() {
    return getBool(keyOnboardingCompleted) ?? false;
  }

  // Search history methods
  static Future<bool> addToSearchHistory(String query) async {
    List<String> history = getSearchHistory();

    // Remove if already exists to avoid duplicates
    history.remove(query);

    // Add to beginning
    history.insert(0, query);

    // Keep only last 20 searches
    if (history.length > 20) {
      history = history.take(20).toList();
    }

    return await saveStringList(keySearchHistory, history);
  }

  static List<String> getSearchHistory() {
    return getStringList(keySearchHistory) ?? [];
  }

  static Future<bool> clearSearchHistory() async {
    return await remove(keySearchHistory);
  }

  // Recently viewed methods
  static Future<bool> addToRecentlyViewed(Map<String, dynamic> item) async {
    List<Map<String, dynamic>> recentlyViewed = getRecentlyViewed();

    // Remove if already exists
    recentlyViewed.removeWhere((existing) =>
        existing['id'] == item['id'] && existing['type'] == item['type']);

    // Add to beginning
    recentlyViewed.insert(0, item);

    // Keep only last 50 items
    if (recentlyViewed.length > 50) {
      recentlyViewed = recentlyViewed.take(50).toList();
    }

    return await saveObjectList(keyRecentlyViewed, recentlyViewed);
  }

  static List<Map<String, dynamic>> getRecentlyViewed() {
    return getObjectList(keyRecentlyViewed) ?? [];
  }

  static Future<bool> clearRecentlyViewed() async {
    return await remove(keyRecentlyViewed);
  }

  // Favorites methods
  static Future<bool> addFavoriteAttraction(int attractionId) async {
    List<String> favorites = getFavoriteAttractions();
    String id = attractionId.toString();

    if (!favorites.contains(id)) {
      favorites.add(id);
      return await saveStringList(keyFavoriteAttractions, favorites);
    }
    return true;
  }

  static Future<bool> removeFavoriteAttraction(int attractionId) async {
    List<String> favorites = getFavoriteAttractions();
    String id = attractionId.toString();

    if (favorites.contains(id)) {
      favorites.remove(id);
      return await saveStringList(keyFavoriteAttractions, favorites);
    }
    return true;
  }

  static List<String> getFavoriteAttractions() {
    return getStringList(keyFavoriteAttractions) ?? [];
  }

  static bool isAttractionFavorite(int attractionId) {
    return getFavoriteAttractions().contains(attractionId.toString());
  }

  static Future<bool> addFavoriteAccommodation(int accommodationId) async {
    List<String> favorites = getFavoriteAccommodations();
    String id = accommodationId.toString();

    if (!favorites.contains(id)) {
      favorites.add(id);
      return await saveStringList(keyFavoriteAccommodations, favorites);
    }
    return true;
  }

  static Future<bool> removeFavoriteAccommodation(int accommodationId) async {
    List<String> favorites = getFavoriteAccommodations();
    String id = accommodationId.toString();

    if (favorites.contains(id)) {
      favorites.remove(id);
      return await saveStringList(keyFavoriteAccommodations, favorites);
    }
    return true;
  }

  static List<String> getFavoriteAccommodations() {
    return getStringList(keyFavoriteAccommodations) ?? [];
  }

  static bool isAccommodationFavorite(int accommodationId) {
    return getFavoriteAccommodations().contains(accommodationId.toString());
  }

  // Offline data methods
  static Future<bool> saveOfflineData(Map<String, dynamic> data) async {
    return await saveObject(keyOfflineData, data);
  }

  static Map<String, dynamic>? getOfflineData() {
    return getObject(keyOfflineData);
  }

  // Sync time methods
  static Future<bool> saveLastSyncTime(DateTime time) async {
    return await saveString(keyLastSyncTime, time.toIso8601String());
  }

  static DateTime? getLastSyncTime() {
    final timeString = getString(keyLastSyncTime);
    if (timeString != null) {
      try {
        return DateTime.parse(timeString);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // Notification settings methods
  static Future<bool> saveNotificationSettings(
      Map<String, bool> settings) async {
    return await saveObject(keyNotificationSettings, settings);
  }

  static Map<String, bool> getNotificationSettings() {
    final settings = getObject(keyNotificationSettings);
    if (settings != null) {
      return settings.map((key, value) => MapEntry(key, value as bool));
    }
    return {
      'booking_updates': true,
      'promotional_offers': true,
      'event_reminders': true,
      'location_based': false,
    };
  }

  // Location permission methods
  static Future<bool> setLocationPermissionAsked() async {
    return await saveBool(keyLocationPermissionAsked, true);
  }

  static bool wasLocationPermissionAsked() {
    return getBool(keyLocationPermissionAsked) ?? false;
  }
}
