import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:prototype_demo/models/nama_balai.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalNamaBalai {
  final String dbName = 'nama_balai.db';
  final int dbVersion = 1;

  final String tableNamaBalai = 'nama_balai';

  final String id = 'id';
  final String nama = 'nama';

  static Database? _database;

  Future<Database?> database() async {
    if (_database != null) return _database;
    _database = await initDb();
    return _database;
  }

  initDb() async {
    Directory documentDir = await getApplicationDocumentsDirectory();
    String path = join(documentDir.path, dbName);
    return await openDatabase(
      path,
      version: dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
      CREATE TABLE $tableNamaBalai (
        $id INTEGER PRIMARY KEY,
        $nama TEXT NOT NULL
      )
    ''');
      },
    );
  }

  Future<int> insertNamaBalai(NamaBalai namaBalai) async {
    Database? db = await database();
    return await db!.insert(tableNamaBalai, namaBalai.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<NamaBalai>> getAllNamaBalai() async {
    Database? db = await database();
    var result = await db!.query(tableNamaBalai);
    return result.map((json) => NamaBalai.fromJson(json)).toList();
  }

  Future<List<int>> getAllNamaBalaiId() async {
    Database? db = await database();
    List<Map<String, dynamic>> maps =
        await db!.query(tableNamaBalai, columns: [id]);
    return List.generate(maps.length, (i) => maps[i][id] as int);
  }

  Future<List<NamaBalai>> getNamaBalaiPaginated(int offset, int limit) async {
    Database? db = await database();
    var result = await db!.query(
      tableNamaBalai,
      limit: limit,
      offset: offset,
      orderBy: '$nama ASC',
    );
    return result.map((json) => NamaBalai.fromJson(json)).toList();
  }

  Future<int> getTotalNamaBalaiCount() async {
    Database? db = await database();
    var result = await db!.rawQuery('SELECT COUNT(*) FROM $tableNamaBalai');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<List<NamaBalai>> searchNamaBalai(String query) async {
    Database? db = await database();
    final List<Map<String, dynamic>> maps = await db!.query(
      'nama_balai',
      where: 'nama LIKE ?',
      whereArgs: ['%$query%'],
    );
    return List.generate(maps.length, (i) => NamaBalai.fromJson(maps[i]));
  }
}
