import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';

class SQLiteService {
  static const String _dbName = 'cigarette_tracker.db';
  static const int _dbVersion = 1;
  static const String _tableName = 'cigarette_counts';

  static Future<Database> _openDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            date TEXT PRIMARY KEY,
            counts TEXT
          )
        ''');
      },
    );
  }

  static Future<void> decrementCigaretteCount(DateTime dateTime) async {
    final db = await _openDatabase();
    final date = dateTime.toIso8601String().substring(0, 10);
    final hour = dateTime.hour.toString().padLeft(2, '0');

    try {
      await db.transaction((txn) async {
        final result = await txn.query(_tableName, where: 'date = ?', whereArgs: [date]);
        if (result.isNotEmpty) {
          final counts = json.decode(result.first['counts'] as String) as Map<String, dynamic>;
          if (counts.containsKey(hour) && counts[hour]! > 0) {
            counts[hour] = counts[hour]! - 1;
            if (counts[hour] == 0) {
              counts.remove(hour);
            }
            await txn.update(_tableName, {'counts': json.encode(counts)}, where: 'date = ?', whereArgs: [date]);
          }
        }
      });
    } finally {
      await db.close();
    }
  }

  static Future<void> incrementCigaretteCount(DateTime dateTime) async {
    final db = await _openDatabase();
    final date = dateTime.toIso8601String().substring(0, 10);
    final hour = dateTime.hour.toString().padLeft(2, '0');

    try {
      await db.transaction((txn) async {
        final result = await txn.query(_tableName, where: 'date = ?', whereArgs: [date]);
        if (result.isNotEmpty) {
          final counts = json.decode(result.first['counts'] as String) as Map<String, dynamic>;
          counts[hour] = (counts[hour] ?? 0) + 1;
          await txn.update(_tableName, {'counts': json.encode(counts)}, where: 'date = ?', whereArgs: [date]);
        } else {
          await txn.insert(_tableName, {'date': date, 'counts': json.encode({hour: 1})});
        }
      });
    } finally {
      await db.close();
    }
  }

  static Future<Map<String, int>> getCigaretteCounts(String date) async {
    final db = await _openDatabase();
    try {
      final result = await db.query(_tableName, where: 'date = ?', whereArgs: [date]);
      if (result.isNotEmpty) {
        final counts = json.decode(result.first['counts'] as String) as Map<String, dynamic>;
        return counts.map((key, value) => MapEntry(key, value as int));
      }
      return {};
    } finally {
      await db.close();
    }
  }

  static Future<void> resetCounts(String date) async {
    final db = await _openDatabase();
    try {
      await db.delete(_tableName, where: 'date = ?', whereArgs: [date]);
    } finally {
      await db.close();
    }
  }

  static Future<Map<DateTime, int>> getWeeklyData() async {
    final db = await _openDatabase();
    final endDate = DateTime.now();
    final startDate = endDate.subtract(Duration(days: 30));

    try {
      final result = await db.query(
        _tableName,
        where: 'date BETWEEN ? AND ?',
        whereArgs: [startDate.toIso8601String().substring(0, 10), endDate.toIso8601String().substring(0, 10)],
      );

      Map<DateTime, int> weeklyData = {};
      for (var row in result) {
        final date = DateTime.parse(row['date'] as String);
        final counts = json.decode(row['counts'] as String) as Map<String, dynamic>;
        final totalCount = counts.values.fold(0, (sum, count) => sum + (count as int));
        weeklyData[date] = totalCount;
      }
      return weeklyData;
    } finally {
      await db.close();
    }
  }

  static Future<List<Map<String, dynamic>>> getWeeklyCounts() async {
    final db = await _openDatabase();
    final endDate = DateTime.now();
    final startDate = endDate.subtract(Duration(days: 7));

    try {
      final result = await db.query(
        _tableName,
        where: 'date BETWEEN ? AND ?',
        whereArgs: [startDate.toIso8601String().substring(0, 10), endDate.toIso8601String().substring(0, 10)],
      );

      return result.map((row) => {
        'date': row['date'],
        'counts': json.decode(row['counts'] as String),
      }).toList();
    } finally {
      await db.close();
    }
  }
}