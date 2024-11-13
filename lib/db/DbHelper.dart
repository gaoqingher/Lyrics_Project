import 'package:sqflite/sqflite.dart';

import '../bean/lyric_bean.dart';

class DbHelper {
  static const sqlName = "db.sqlite";
  static const tableName = "lyricLibrary";
  Database? db;
  static DbHelper? _instance;

  /// 创建table 的 sql语句
  static var CREATE_DATA_TABLE = '''
        CREATE TABLE lyricLibrary (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        number TEXT,
        firstLine TEXT)
        ''';

  static Future<DbHelper> getInstance() async {
    _instance ??= await _initDataBase();
    return _instance!;
  }

  /// 打开 数据库 db
  static Future<DbHelper> _initDataBase() async {
    DbHelper manager = DbHelper();
    String dbPath = "${await getDatabasesPath()}/$sqlName";

    manager.db ??= await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        /// 如果不存在 当前的表 就创建需要的表
        if (await manager.isTableExit() == false) {
          await db.execute(CREATE_DATA_TABLE);
        }
      },
    );
    return manager;
  }

  ///批量插入
  Future<int> insertList(List<LyricBean> lists) async {
    if (lists.isEmpty || db == null) {
      return 0;
    } else {
      try {
        var batch = db!.batch();
        for (var element in lists) {
          //await insertLyric(element);
          batch.insert(tableName, element.toMap());
        }
        await batch.commit();
        return lists.length;
      } catch (e) {
        return 0;
      }
    }
  }

  /// return 0 表示沒有插入成功
  Future<int> insertLyric(LyricBean lyricBean) async {
    // Get a reference to the database.

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    return await db?.insert(
          tableName,
          lyricBean.toMap(),
          // conflictAlgorithm: ConflictAlgorithm.replace,
        ) ??
        0;
  }

  Future<List<LyricBean>> query(String searchString) async {
    List<Map<String, dynamic>> maps = await db?.query(tableName,
            columns: ['name', 'number','firstLine'],
            where: 'name LIKE ? OR number LIKE ? OR firstLine LIKE ?',
            whereArgs: ['%$searchString%', '%$searchString%', '%$searchString%']) ??
        [];
    return [
      for (final {
            'name': name as String,
            'number': number as String,
            'firstLine': firstLine as String,
          } in maps)
        LyricBean(name: name, number: number,firstLine: firstLine),
    ];
  }

  /// 判断是否存在 数据库表
  Future<bool> isTableExit() async {
    var result = await db?.rawQuery(
        "select * from Sqlite_master where type = 'table' and name = '$tableName'");
    return result?.isNotEmpty ?? false;
  }

  ///获取当前数据库中所有的count
  Future<int> queryAllCount() async {
    final List<Map<String, Object?>> allMaps = await db?.query(tableName) ?? [];
    return allMaps.length;
  }
}
