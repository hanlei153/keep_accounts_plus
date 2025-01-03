import 'package:flutter/material.dart';

import 'Widgets/date_picker_year_month_day.dart';
import '../common/common_future/select_sqflte.dart';
import 'analyze/pie_chart.dart';

class AnalyzePage extends StatefulWidget {
  AnalyzePage({super.key});
  @override
  State<AnalyzePage> createState() => _AnalyzePageState();
}

class _AnalyzePageState extends State<AnalyzePage> {
  Map<String, double> data = {};
  String? selectedType = '支出';
  int startYear = DateTime.now().year;
  int startMonth = DateTime.now().month;
  int startDay = 1;
  int endYear = DateTime.now().year;
  int endMonth = DateTime.now().month;
  int endDay = DateTime.now().day;

  // 加载账单
  Future<Map<String, double>> _selectedRangeBills() async {
    String startDate =
        '$startYear-${startMonth.toString().padLeft(2, '0')}-${startDay.toString().padLeft(2, '0')}';
    String endDate =
        '$endYear-${endMonth.toString().padLeft(2, '0')}-${endDay.toString().padLeft(2, '0')}';
    final results = await selectedRangeBills(startDate, endDate, selectedType!);
    Map<String, double> groupBills = {};

    for (var item in results) {
      // 取出 category 和 amount
      String category = item['category'];
      double itemAmount = item['amount'];

      if (groupBills.containsKey(category)) {
        // 累加已有金额
        double groupAmount = groupBills[category] ?? 0.0;
        groupBills[category] = groupAmount + itemAmount;
      } else {
        // 如果该 category 没有，则初始化金额
        groupBills[category] = itemAmount;
      }
    }
    return groupBills;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // 根据不同的分类给饼图每个扇区设置颜色
    Color _getColorForCategory(String category) {
      switch (category) {
        case '餐饮':
          return Colors.blue;
        case '水果':
          return Colors.green;
        case '购物':
          return Colors.orange;
        case '交通':
          return Colors.red;
        case '娱乐':
          return const Color.fromRGBO(51, 145, 233, 0.8);
        case '住房':
          return const Color.fromRGBO(117, 223, 56, 0.8);
        case '社交':
          return const Color.fromRGBO(236, 204, 62, 0.8);
        case '旅行':
          return const Color.fromRGBO(87, 188, 255, 0.8);
        case '宠物':
          return const Color.fromRGBO(255, 99, 99, 0.8);
        case '医疗':
          return const Color.fromRGBO(116, 255, 174, 0.8);
        case '服饰':
          return const Color.fromRGBO(102, 255, 255, 0.8);
        case '工资':
          return const Color.fromRGBO(135, 181, 250, 0.8);
        case '兼职':
          return const Color.fromRGBO(127, 255, 191, 0.8);
        case '理财':
          return const Color.fromRGBO(156, 247, 231, 0.8);
        case '礼金':
          return const Color.fromRGBO(209, 110, 226, 0.8);
        default:
          return Colors.grey;
      }
    }

    // 选择日期组件
    final selectedDaysWidget = GestureDetector(
      onTap: () async {
        final (startyear, startmonth, startday) = await DatePicker.show(
            context, startYear, startMonth, startDay, '选择起始日期');
        if (startyear == 0 && startmonth == 0 && startday == 0) {
          return;
        } else {
          final (endyear, endmonth, endday) = await DatePicker.show(
              context, endYear, endMonth, endDay, '选择结束日期');
          if (endyear == 0 && endmonth == 0 && endday == 0) {
            return;
          } else {
            setState(() {
              startYear = startyear;
              startMonth = startmonth;
              startDay = startday;
              endYear = endyear;
              endMonth = endmonth;
              endDay = endday;
            });
          }
        }
      },
      child: Row(
        children: [
          Text(
            '$startYear年$startMonth月$startDay日—$endYear年$endMonth月$endDay日',
            style: TextStyle(fontSize: 13),
          ),
          const Icon(Icons.arrow_drop_down)
        ],
      ),
    );
    // 选择类型组件
    final selectedTypeWidget = Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                selectedType = '支出';
              });
            },
            child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: selectedType == '支出'
                        ? const Color.fromARGB(255, 190, 190, 190)
                        : Colors.grey.shade200,
                    borderRadius: selectedType == '支出'
                        ? BorderRadius.circular(10)
                        : const BorderRadius.only(
                            topRight: Radius.circular(0),
                            bottomRight: Radius.circular(0),
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10))),
                child: const Text('支出')),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                selectedType = '收入';
              });
            },
            child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: selectedType == '收入'
                      ? const Color.fromARGB(255, 190, 190, 190)
                      : Colors.grey.shade200,
                  borderRadius: selectedType == '收入'
                      ? BorderRadius.circular(10)
                      : const BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                          topLeft: Radius.circular(0),
                          bottomLeft: Radius.circular(0)),
                ),
                child: const Text('收入')),
          ),
        ],
      ),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Center(child: Text('账单分析')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                selectedDaysWidget,
                selectedTypeWidget,
              ],
            ),
            FutureBuilder<Map<String, double>>(
                future: _selectedRangeBills(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('data is empty');
                  } else {
                    return Column(
                      children: [
                        SizedBox(
                            height: 300,
                            width: 300,
                            child: PieChartWidget(
                                sections: PieChartWidget.generateSections(
                                    snapshot.data!))),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children:
                                List.generate(snapshot.data!.length, (index) {
                              // 获取 Map 的键
                              String key = snapshot.data!.keys.elementAt(index);

                              return Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: _getColorForCategory(key),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    key,
                                    style: const TextStyle(fontSize: 16),
                                  )
                                ],
                              );
                            })),
                      ],
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
