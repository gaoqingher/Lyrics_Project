import 'dart:io';

import 'package:sqflite/sqflite.dart'
    if (dart.library.html) 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite_dev.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static late Database _database;

  // Singleton pattern
  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  // 获取数据库实例
  Future<Database> get database async {
    if (_database.isOpen) {
      return _database;
    }
    _database = await _initDatabase();
    return _database;
  }

  // 初始化数据库
  Future<Database> _initDatabase() async {
    if (Platform.isAndroid || Platform.isIOS) {
      // 使用 sqflite 库进行初始化（移动平台）
      String path = await getDatabasesPath();
      return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) {
          return db.execute('''
            CREATE TABLE lyricLibrary (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        number TEXT,
        firstLine TEXT)
          ''');
        },
      );
    } else if (Platform.isMacOS ||
        Platform.isLinux ||
        Platform.isWindows ||
        Platform.isFuchsia) {
      // 使用 sqflite_common_ffi 库进行初始化（桌面平台）
      sqfliteFfiInit();

      String dbPath = await sqfliteDatabaseFactoryDefault.getDatabasesPath();
      return await databaseFactoryFfi.openDatabase(dbPath);
    } else if (Platform.isWindows) {
      // Web 平台使用 sqflite_common_ffi，默认会使用内存数据库
      sqfliteFfiInit();
      return await databaseFactoryFfi.openDatabase(':memory:');
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  // 创建表
  Future<void> createTable() async {
    final db = await database;
    await db.execute('''
      CREATE TABLE lyricLibrary (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        number TEXT,
        firstLine TEXT)
    ''');
  }

  // 插入用户
  Future<int> insertUser(String number, String name, String? firstLine) async {
    final db = await database;
    return await db.insert(
      'lyricLibrary',
      {'name': name, 'number': number, 'firstLine': firstLine ?? ""},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // 查询所有用户
  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    return await db.query('lyricLibrary');
  }

  // 查询用户通过ID
  Future<Map<String, dynamic>?> getUserById(String searchString) async {
    final db = await database;
    var result = await db.query(
      'lyricLibrary',
      where: 'name LIKE ? OR number LIKE ? OR firstLine LIKE ?',
      whereArgs: ['%$searchString%', '%$searchString%', '%$searchString%'],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // 更新用户
  Future<int> updateUser(int id, String name, int age) async {
    final db = await database;
    return await db.update(
      'users',
      {'name': name, 'age': age},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 删除用户
  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 关闭数据库
  Future<void> closeDatabase() async {
    final db = await database;
    await db.close();
  }
}
