import '../../sqflite/database_helper.dart';

// 月支出账单
Future<dynamic> monthDisburseBill(int year, int month) async {
  String monthStr = month.toString().padLeft(2, '0');
  String yearStr = year.toString();
  String yearMonthStr = '$yearStr-$monthStr';
  return await DatabaseHelper.instance.database.then((db) {
    final res = db.rawQuery(
        'SELECT SUM(amount) AS TotalAmount FROM bills WHERE type = "支出" AND date BETWEEN? AND?',
        ['$yearMonthStr-01', '$yearMonthStr-31']);
    print(res);
    return db.rawQuery(
        'SELECT SUM(amount) AS TotalAmount FROM bills WHERE type = "支出" AND date BETWEEN? AND?',
        ['$yearMonthStr-01', '$yearMonthStr-31']);
  });
}

// 月收入账单
Future<dynamic> monthIncomeBill(int year, int month) async {
  String monthStr = month.toString().padLeft(2, '0');
  String yearStr = year.toString();
  String yearMonthStr = '$yearStr-$monthStr';
  return await DatabaseHelper.instance.database.then((db) {
    return db.rawQuery(
        'SELECT SUM(amount) AS TotalAmount FROM bills WHERE type = "收入" AND date BETWEEN? AND?',
        ['$yearMonthStr-01', '$yearMonthStr-31']);
  });
}

//月账单详细列表
Future<dynamic> monthBills(int year, int month) async {
  String monthStr = month.toString().padLeft(2, '0');
  String yearStr = year.toString();
  String yearMonthStr = '$yearStr-$monthStr';
  return await DatabaseHelper.instance.database.then((db) {
    return db.query(
      'bills',
      where: 'date BETWEEN ? AND ?',
      whereArgs: ['$yearMonthStr-01', '$yearMonthStr-31'],
      orderBy: 'date DESC',
    );
  });
}
