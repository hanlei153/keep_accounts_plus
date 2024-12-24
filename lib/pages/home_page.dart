import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../sqflite/database_helper.dart';
import 'Toast/flutter_toast.dart';
import 'Widgets/date_picker.dart';
import 'Widgets/dialog/alert_dialog.dart';
import '../common/model/bill_info.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Map<String, IconData> incomeIconData = {
    '工资': Icons.work,
    '兼职': Icons.business_center,
    '理财': Icons.attach_money,
    '礼金': Icons.card_giftcard,
    '其他': Icons.more_horiz,
  };

  final Map<String, IconData> disburseIconData = {
    '餐饮': Icons.local_dining,
    '水果': Icons.fastfood,
    '购物': Icons.shopping_cart,
    '交通': Icons.directions_car,
    '娱乐': Icons.movie,
    '住房': Icons.house,
    '社交': Icons.group,
    '旅行': Icons.travel_explore,
    '宠物': Icons.pets,
    '医疗': Icons.local_hospital,
    '服饰': Icons.shopping_bag,
    '其他': Icons.more_horiz,
  };
  List<Map<String, dynamic>> _bills = [];
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;
  String disbursement = '';
  String income = '';

  // 初始化
  @override
  void initState() {
    super.initState();
    refreshBills(selectedYear, selectedMonth);
    incomeBill(selectedYear, selectedMonth);
    disburseBill(selectedYear, selectedMonth);
  }

  // 月支出账单
  Future<void> disburseBill(int year, int month) async {
    String monthStr = month.toString().padLeft(2, '0');
    String yearStr = year.toString();
    String yearMonthStr = '$yearStr-$monthStr';
    final results = await DatabaseHelper.instance.database.then((db) {
      return db.rawQuery(
          'SELECT SUM(amount) AS TotalAmount FROM bills WHERE type = "支出" AND date BETWEEN? AND?',
          ['$yearMonthStr-01', '$yearMonthStr-31']);
    });
    setState(() {
      if (results[0]['TotalAmount'] == null) {
        disbursement = '0';
      } else {
        disbursement = results[0]['TotalAmount'].toString();
      }
    });
  }

  // 月收入账单
  Future<void> incomeBill(int year, int month) async {
    String monthStr = month.toString().padLeft(2, '0');
    String yearStr = year.toString();
    String yearMonthStr = '$yearStr-$monthStr';
    final results = await DatabaseHelper.instance.database.then((db) {
      return db.rawQuery(
          'SELECT SUM(amount) AS TotalAmount FROM bills WHERE type = "收入" AND date BETWEEN? AND?',
          ['$yearMonthStr-01', '$yearMonthStr-31']);
    });
    setState(() {
      if (results[0]['TotalAmount'] == null) {
        income = '0';
      } else {
        income = results[0]['TotalAmount'].toString();
      }
    });
  }

  //月账单详细列表
  Future<void> refreshBills(int year, int month) async {
    String monthStr = month.toString().padLeft(2, '0');
    String yearStr = year.toString();
    String yearMonthStr = '$yearStr-$monthStr';
    final bills = await DatabaseHelper.instance.database.then((db) {
      return db.query(
        'bills',
        where: 'date BETWEEN ? AND ?',
        whereArgs: ['$yearMonthStr-01', '$yearMonthStr-31'],
      );
    });
    setState(() {
      _bills = bills;
    });
  }

  // 删除所有账单
  void _deleteAllBill() async {
    await DatabaseHelper.instance.database.then((db) {
      return db.delete('bills');
    });
  }

  // 账单分类
  Map<String, List<Map<String, dynamic>>> groupByDate(
      List<Map<String, dynamic>> bills) {
    Map<String, List<Map<String, dynamic>>> groupedBills = {};

    for (var bill in bills) {
      String date = bill['date'];

      // 如果日期没有出现过，初始化一个空的列表
      if (!groupedBills.containsKey(date)) {
        groupedBills[date] = [];
      }

      // 将当前账单添加到对应日期的列表中
      groupedBills[date]?.add(bill);
    }

    return groupedBills;
  }

  // appBar样式
  static TextStyle yearStyle = const TextStyle(
    fontSize: 14,
    color: Color.fromARGB(255, 66, 66, 66),
  );
  static TextStyle monthStyle = const TextStyle(
    fontSize: 22,
  );
  static TextStyle billStyle = const TextStyle(
    fontSize: 16,
  );

  @override
  Widget build(BuildContext context) {
    // 获取分组后的账单数据
    final groupedBills = groupByDate(_bills);
    return Scaffold(
      appBar: AppBar(
        title: Column(children: [
          const Text('记账Plus'),
          const SizedBox(height: 10.0),
          Row(
            children: [
              GestureDetector(
                onTap: () async {
                  final (year, month) = await DatePicker.show(
                      context, selectedYear, selectedMonth);
                  setState(() {
                    if (year == 0 && month == 0) {
                      return;
                    }
                    selectedYear = year;
                    selectedMonth = month;
                    refreshBills(selectedYear, selectedMonth);
                    incomeBill(selectedYear, selectedMonth);
                    disburseBill(selectedYear, selectedMonth);
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '${selectedYear.toString()}年',
                        style: yearStyle,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            selectedMonth.toString(),
                            style: monthStyle,
                          ),
                          const Text(' 月', style: TextStyle(fontSize: 16)),
                          const Icon(
                            Icons.arrow_drop_down,
                            size: 25,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.1),
              Text(
                '支出: $disbursement',
                style: billStyle,
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.2),
              Text(
                '收入: $income',
                style: billStyle,
              ),
            ],
          ),
        ]),
        backgroundColor: Theme.of(context).colorScheme.primary,
        toolbarHeight: MediaQuery.of(context).size.height * 0.13,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: RefreshIndicator(
          onRefresh: () async {
            refreshBills(selectedYear, selectedMonth);
            incomeBill(selectedYear, selectedMonth);
            disburseBill(selectedYear, selectedMonth);
            showSuccessToast(msg: '刷新成功');
          },
          displacement: 5.0,
          child: ListView.builder(
            itemCount: groupedBills.keys.length,
            itemBuilder: (context, index) {
              // 获取日期
              String date = groupedBills.keys.elementAt(index);
              List<Map<String, dynamic>> billsOnDate = groupedBills[date]!;

              return Card(
                margin: const EdgeInsets.only(bottom: 30),
                elevation: 8.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        date,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    // 显示该日期下的所有账单
                    ...billsOnDate.map((bill) {
                      return GestureDetector(
                        onTap: () {
                          final Bill billInfo = Bill.fromJson(bill);
                          showBillDialog(
                              context: context,
                              title: '详情',
                              content1: billInfo);
                        },
                        child: ListTile(
                          title:
                              Text("${bill['category']} - ${bill['amount']}"),
                          subtitle: Text(bill['note'],
                              maxLines: 1,
                              style: const TextStyle(fontSize: 12)),
                          trailing: Text(bill['type']),
                        ),
                      );
                    }),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
