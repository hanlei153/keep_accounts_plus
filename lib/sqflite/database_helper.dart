import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app.db');
    return _database!;
  }

  Future<Database> _initDB(String filename) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filename);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  //  amount:金额  category:类型  type:收入/支出  date:日期  note:备注
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
        CREATE TABLE BILLS (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          amount REAL,
          category TEXT,
          type TEXT,
          date TEXT,
          note TEXT)
    ''');
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }

  // // 增
  // Future<void> addBill(double amount, String category, String date, String note,
  //     String type) async {
  //   final db = await DatabaseHelper.instance.database;

  //   await db.insert(
  //     'bills',
  //     {
  //       'amount': amount,
  //       'category': category,
  //       'type': type,
  //       'date': date,
  //       'note': note,
  //     },
  //   );
  // }

  // // 查
  // Future<List<Map<String, dynamic>>> getAllBills() async {
  //   final db = await DatabaseHelper.instance.database;
  //   return await db.query('bills');
  // }

  // Future<List<Map<String, dynamic>>> getBillsByCategory(String category) async {
  //   final db = await DatabaseHelper.instance.database;
  //   return await db
  //       .query('bills', where: 'category = ?', whereArgs: [category]);
  // }

  // // 删
  // Future<void> deleteBill(int id) async {
  //   final db = await DatabaseHelper.instance.database;
  //   await db.delete('bills', where: 'id = ?', whereArgs: [id]);
  // }
}
