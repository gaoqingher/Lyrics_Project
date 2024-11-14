import 'dart:io' as io;
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  // 单例数据库对象
  static Database? _database;

  // 表名和字段名
  static const String table = 'lyrics';
  static const String columnNumber = 'number';
  static const String columnName = 'name';
  static const String columnFirstLine = 'firstLine';

  // 获取数据库路径
  Future<String> _getDatabasePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return join(directory.path, 'my_database.db');
  }

  // 初始化数据库
  Future<Database> _initDatabase() async {
    if (_database != null) return _database!;

    // 检查平台，选择对应的 sqflite 库
    if (Platform.isAndroid || Platform.isIOS) {
      // 使用 sqflite（适用于 Android/iOS）
      _database = await openDatabase(
        await _getDatabasePath(),
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
          CREATE TABLE $table(
            $columnNumber TEXT PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnFirstLine TEXT
          )
          ''');
        },
      );
    } else {
      // 使用 sqflite_common_ffi（适用于桌面平台）
      sqfliteFfiInit(); // 初始化 FFI

      _database = await databaseFactory.openDatabase(
        await _getDatabasePath(),
        options: OpenDatabaseOptions(
          onCreate: (db, version) async {
            await db.execute('''
            CREATE TABLE $table(
              $columnNumber TEXT PRIMARY KEY,
              $columnName TEXT NOT NULL,
              $columnFirstLine TEXT
            )
            ''');
          },
        ),
      );
    }
    return _database!;
  }

  // 插入数据
  Future<void> insertItem(String number, String name, String? firstLine) async {
    final db = await _initDatabase();
    await db.insert(
      table,
      {
        columnNumber: number,
        columnName: name,
        columnFirstLine: firstLine,
      },
      conflictAlgorithm: ConflictAlgorithm.replace, // 如果已有相同的 primary key，将会替换
    );
  }

  // 查询单条数据
  Future<List<Map<String, String>>?> getItem(String number) async {
    final db = await _initDatabase();
    List<Map<String, String>> result = await db.query(
      table,
      where: '$columnNumber = ?',
      whereArgs: [number],
    );
    if (result.isNotEmpty) {
      return result; // 返回查询结果的第一条数据
    }
    return null; // 如果没有数据，则返回 null
  }


  // 插入多条数据
  Future<void> insertAllItems(List<Map<String, String>> items) async {
    final db = await _initDatabase();
    // 使用事务来批量插入数据
    await db.transaction((txn) async {
      for (var item in items) {
        await txn.insert(
          table,
          item,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }
// 查询所有数据
  Future<int> getItemCount() async {
    final db = await _initDatabase();
    // 使用 SELECT COUNT(*) 来获取表中记录数
    var result = await db.rawQuery('SELECT COUNT(*) FROM $table');
    return Sqflite.firstIntValue(result) ?? 0;  // 如果没有数据，返回 0
  }
}
