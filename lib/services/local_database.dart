import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:prototype_demo/models/product.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabase {
  final String dbName = 'saved_data_local.db';
  final int dbVersion = 1;

  String tableName = 'products';
  String id = 'id';
  String product = 'product';
  String price = 'price';

  Database? _database;

  Future<Database?> database() async {
    if (_database != null) return _database;
    _database = await initDb();
    return _database;
  }

  initDb() async {
    Directory documentDir = await getApplicationDocumentsDirectory();
    String path = join(documentDir.path, dbName);
    return openDatabase(
      path,
      version: dbVersion,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE $tableName($id INTEGER PRIMARY KEY, $product TEXT, $price REAL)',
        );
      },
    );
  }

  Future<List<Product>> getAll() async {
    List<Product> result = [];
    try {
      final db = await database();
      final data = await db!.query(tableName);
      result = data.map((e) => Product.fromJson(e)).toList();
    } catch (e) {
      print("error getAll: $e");
    }
      return result;
  }

  Future<int> insert(Map<String, dynamic> values) async {
    final db = await database();
    final query = await db!.insert(tableName, values);
    print("insert query $query");
    return query;
  }
}
