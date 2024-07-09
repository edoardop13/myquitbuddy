import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPreferencesService {
  static const String _cigaretteCountsKey = 'cigaretteCounts';
  static const String _lastDateKey = 'lastDate';

  static Future<Map<String, int>> getCigaretteCounts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? countsJson = prefs.getString(_cigaretteCountsKey);
    if (countsJson == null) {
      return {};
    }
    Map<String, dynamic> counts = json.decode(countsJson);
    return counts.map((key, value) => MapEntry(key, value as int));
  }

  static Future<void> setCigaretteCounts(Map<String, int> counts) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String countsJson = json.encode(counts);
    await prefs.setString(_cigaretteCountsKey, countsJson);
  }

  static Future<void> incrementCigaretteCount(int hour) async {
    Map<String, int> counts = await getCigaretteCounts();
    String hourKey = hour.toString().padLeft(2, '0');
    counts[hourKey] = (counts[hourKey] ?? 0) + 1;
    await setCigaretteCounts(counts);
  }

  static Future<String?> getLastDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastDateKey);
  }

  static Future<void> setLastDate(String date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastDateKey, date);
  }

  static Future<void> resetCounts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cigaretteCountsKey);
  }
}