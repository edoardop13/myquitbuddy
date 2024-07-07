import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const String _cigaretteCountKey = 'cigaretteCount';
  static const String _lastDateKey = 'lastDate';

  static Future<int> getCigaretteCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_cigaretteCountKey) ?? 0;
  }

  static Future<void> setCigaretteCount(int count) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_cigaretteCountKey, count);
  }

  static Future<String?> getLastDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastDateKey);
  }

  static Future<void> setLastDate(String date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastDateKey, date);
  }
}
