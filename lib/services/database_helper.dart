import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/mata_air.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('mataair.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE mata_air(
        local_id TEXT PRIMARY KEY,
        id INTEGER,
        nama TEXT,
        kota TEXT,
        is_sync INTEGER,
        last_modified TEXT
      )
    ''');
  }

  Future<int> insertMataAir(MataAir mataAir) async {
    final db = await instance.database;
    return await db.insert('mata_air', mataAir.toMap());
  }

  Future<List<MataAir>> getAllMataAir() async {
    final db = await instance.database;
    final result = await db.query('mata_air');
    return result.map((json) => MataAir.fromMap(json)).toList();
  }

  Future<int> updateMataAir(MataAir mataAir) async {
    final db = await instance.database;
    return await db.update(
      'mata_air',
      mataAir.toMap(),
      where: 'local_id = ?',
      whereArgs: [mataAir.localId],
    );
  }

  Future<int> deleteMataAir(String localId) async {
    final db = await instance.database;
    return await db.delete(
      'mata_air',
      where: 'local_id = ?',
      whereArgs: [localId],
    );
  }

  Future<List<MataAir>> getUnsyncedMataAir() async {
    final db = await instance.database;
    final result = await db.query('mata_air', where: 'is_sync = 0');
    return result.map((json) => MataAir.fromMap(json)).toList();
  }

  Future<int> updateMataAirSyncStatus(String localId, bool isSync) async {
    final db = await instance.database;
    return await db.update(
      'mata_air',
      {'is_sync': isSync ? 1 : 0},
      where: 'local_id = ?',
      whereArgs: [localId],
    );
  }
}
