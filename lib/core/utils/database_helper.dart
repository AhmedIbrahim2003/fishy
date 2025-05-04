import 'dart:developer';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('fishy.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    log(path);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE saved_catchs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fish_name TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        photo_path TEXT NOT NULL,
        confidence REAL NOT NULL
      )
    ''');
  }

  Future<int> insertCatch({
    required String fishName,
    required String timestamp,
    required String photoPath,
    required double confidence,
  }) async {
    final db = await instance.database;

    final id = await db.insert('saved_catchs', {
      'fish_name': fishName,
      'timestamp': timestamp,
      'photo_path': photoPath,
      'confidence': confidence,
    });
    _printAllCatches();
    log(id.toString());
    return id; 
  }

  Future<int> deleteCatch(int id) async {
    final db = await instance.database;
    return await db.delete(
      'saved_catchs',
      where: 'id = ?',
      whereArgs: [id],
    ).then((value) {
      _printAllCatches();
      return value;
    });
  }

  Future<List<Map<String, dynamic>>> getAllCatches() async {
    final db = await instance.database;
    return await db.query('saved_catchs', orderBy: 'timestamp DESC');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future<void> _printAllCatches() async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> results = await db.query('saved_catchs');

    for (var row in results) {
      log(row.toString());
    }
  }
}
