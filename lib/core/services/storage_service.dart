import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ── User Preferences (SharedPreferences) ──────
  static Future<void> setString(String key, String value) =>
      _prefs.setString(key, value);

  static String? getString(String key) => _prefs.getString(key);

  static Future<void> setInt(String key, int value) =>
      _prefs.setInt(key, value);

  static int? getInt(String key) => _prefs.getInt(key);

  static Future<void> setBool(String key, bool value) =>
      _prefs.setBool(key, value);

  static bool? getBool(String key) => _prefs.getBool(key);

  static Future<void> setDouble(String key, double value) =>
      _prefs.setDouble(key, value);

  static double? getDouble(String key) => _prefs.getDouble(key);

  static Future<void> remove(String key) => _prefs.remove(key);

  static Future<void> clear() => _prefs.clear();

  // ── Storage Keys ────────────────────────────────
  static const String keyOnboarded = 'onboarded';
  static const String keyUserId = 'user_id';
  static const String keyUserName = 'user_name';
  static const String keyUserEmail = 'user_email';
  static const String keyUserCollege = 'user_college';
  static const String keyTheme = 'theme_dark';
  static const String keyLanguage = 'language';
  static const String keyCoins = 'coins';
  static const String keyXP = 'xp';
  static const String keyStreak = 'streak';
  static const String keyLastActive = 'last_active';
  static const String keyChatHistory = 'chat_history';
  static const String keyDarkMode = 'dark_mode';
  static const String keySolvedProblems = 'solved_problems';

  // ── JSON-based data storage (replaces Hive) ────
  static Future<void> saveUser(String uid, Map<String, dynamic> userData) =>
      setString('user_$uid', jsonEncode(userData));

  static Map<String, dynamic>? getUser(String uid) {
    final data = getString('user_$uid');
    if (data == null) return null;
    return jsonDecode(data) as Map<String, dynamic>;
  }

  static Future<void> deleteUser(String uid) => remove('user_$uid');

  // ── Problems Cache ────────────────────────────
  static Future<void> saveProblem(String id, Map<String, dynamic> problem) =>
      setString('problem_$id', jsonEncode(problem));

  static Map<String, dynamic>? getProblem(String id) {
    final data = getString('problem_$id');
    if (data == null) return null;
    return jsonDecode(data) as Map<String, dynamic>;
  }

  static Future<void> clearProblems() async {
    final keys = _prefs.getKeys().where((k) => k.startsWith('problem_'));
    for (final key in keys) {
      await remove(key);
    }
  }

  // ── Chat History ────────────────────────────────
  static Future<void> saveChatHistory(
      String threadId, List<Map<String, dynamic>> messages) =>
      setString('chat_$threadId', jsonEncode(messages));

  static List<Map<String, dynamic>>? getChatHistory(String threadId) {
    final data = getString('chat_$threadId');
    if (data == null) return null;
    final List<dynamic> decoded = jsonDecode(data);
    return decoded.cast<Map<String, dynamic>>();
  }

  static Future<void> addChatMessage(
      String threadId, Map<String, dynamic> message) async {
    final history = getChatHistory(threadId) ?? [];
    history.add(message);
    await saveChatHistory(threadId, history);
  }

  static Future<void> deleteChatThread(String threadId) =>
      remove('chat_$threadId');

  // ── Offline Queue ────────────────────────────────
  static Future<void> queueAction(
      String actionId, Map<String, dynamic> data) =>
      setString(
          'offline_$actionId',
          jsonEncode({
            ...data,
            'timestamp': DateTime.now().toIso8601String(),
          }));

  static Future<void> removeOfflineAction(String actionId) =>
      remove('offline_$actionId');

  static Future<void> clearOfflineQueue() async {
    final keys = _prefs.getKeys().where((k) => k.startsWith('offline_'));
    for (final key in keys) {
      await remove(key);
    }
  }
}
