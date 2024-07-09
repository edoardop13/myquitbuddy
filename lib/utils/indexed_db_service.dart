import 'package:idb_shim/idb_client.dart';
import 'package:idb_shim/idb_browser.dart';

class IndexedDBService {
  static const String _dbName = 'cigarette_tracker';
  static const int _dbVersion = 1;
  static const String _storeName = 'cigarette_counts';

  static Future<Database> _openDatabase() async {
    final idbFactory = getIdbFactory();
    if (idbFactory == null) {
      throw Exception('IndexedDB is not supported in this environment');
    }
    return await idbFactory.open(_dbName, version: _dbVersion,
        onUpgradeNeeded: (VersionChangeEvent event) {
      final db = event.database;
      db.createObjectStore(_storeName, keyPath: 'date');
    });
  }

  static Future<void> decrementCigaretteCount(DateTime dateTime) async {
    final db = await _openDatabase();
    final txn = db.transaction(_storeName, 'readwrite');
    final store = txn.objectStore(_storeName);

    final date = dateTime.toIso8601String().substring(0, 10);
    final hour = dateTime.hour.toString().padLeft(2, '0');

    try {
      final existingData = await store.getObject(date) as Map<String, dynamic>?;
      if (existingData != null) {
        final counts = Map<String, int>.from(existingData['counts'] as Map);
        if (counts.containsKey(hour) && counts[hour]! > 0) {
          counts[hour] = counts[hour]! - 1;
          if (counts[hour] == 0) {
            counts.remove(hour);
          }
          await store.put({'date': date, 'counts': counts});
        }
      }
    } finally {
      await txn.completed;
      db.close();
    }
  }

  static Future<void> incrementCigaretteCount(DateTime dateTime) async {
    final db = await _openDatabase();
    final txn = db.transaction(_storeName, 'readwrite');
    final store = txn.objectStore(_storeName);

    final date = dateTime.toIso8601String().substring(0, 10);
    final hour = dateTime.hour.toString().padLeft(2, '0');

    try {
      final existingData = await store.getObject(date) as Map<String, dynamic>?;
      if (existingData != null) {
        final counts = Map<String, int>.from(existingData['counts'] as Map);
        counts[hour] = (counts[hour] ?? 0) + 1;
        await store.put({'date': date, 'counts': counts});
      } else {
        await store.add({'date': date, 'counts': {hour: 1}});
      }
    } finally {
      await txn.completed;
      db.close();
    }
  }

  static Future<Map<String, int>> getCigaretteCounts(String date) async {
    final db = await _openDatabase();
    final txn = db.transaction(_storeName, 'readonly');
    final store = txn.objectStore(_storeName);

    try {
      final data = await store.getObject(date) as Map<String, dynamic>?;
      if (data != null) {
        return Map<String, int>.from(data['counts'] as Map);
      }
      return {};
    } finally {
      await txn.completed;
      db.close();
    }
  }

  static Future<void> resetCounts(String date) async {
    final db = await _openDatabase();
    final txn = db.transaction(_storeName, 'readwrite');
    final store = txn.objectStore(_storeName);

    try {
      await store.delete(date);
    } finally {
      await txn.completed;
      db.close();
    }
  }

  static Future<List<Map<String, dynamic>>> getWeeklyCounts() async {
    final db = await _openDatabase();
    final txn = db.transaction(_storeName, 'readonly');
    final store = txn.objectStore(_storeName);

    try {
      final endDate = DateTime.now();
      final startDate = endDate.subtract(Duration(days: 7));
      final range = KeyRange.bound(
        startDate.toIso8601String().substring(0, 10),
        endDate.toIso8601String().substring(0, 10),
      );

      final List<Map<String, dynamic>> weeklyCounts = [];
      await for (final cursor in store.openCursor(range: range)) {
        weeklyCounts.add(cursor.value as Map<String, dynamic>);
        cursor.next();
      }
      return weeklyCounts;
    } finally {
      await txn.completed;
      db.close();
    }
  }
}