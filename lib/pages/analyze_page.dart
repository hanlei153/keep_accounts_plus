import 'package:flutter/material.dart';

import 'Widgets/date_picker_year_month.dart';

class AnalyzePage extends StatefulWidget {
  AnalyzePage({super.key});
  @override
  State<AnalyzePage> createState() => _AnalyzePageState();
}

class _AnalyzePageState extends State<AnalyzePage> {
  String? selectedType = '支出';
  int startYear = DateTime.now().year;
  int startMonth = DateTime.now().month;
  int endYear = DateTime.now().year;
  int endMonth = DateTime.now().month;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: const Center(child: Text('账单分析')),
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                Positioned(
                    left: 10,
                    child: GestureDetector(
                      onTap: () async {
                        final (startyear, startmonth) = await DatePicker.show(
                            context, startYear, startMonth, '选择起始日期');

                        if (startyear == 0 && startmonth == 0) {
                          return;
                        } else {
                          final (endyear, endmonth) = await DatePicker.show(
                              context, endYear, endMonth, '选择结束日期');
                          if (endyear == 0 && endmonth == 0) {
                            return;
                          } else {
                            setState(() {
                              startYear = startyear;
                              startMonth = startmonth;
                              endYear = endyear;
                              endMonth = endmonth;
                            });
                          }
                        }
                      },
                      child: Row(
                        children: [
                          Text(
                            '$startYear年$startMonth—$endYear年$endMonth',
                            style: TextStyle(fontSize: 16),
                          ),
                          const Icon(Icons.arrow_drop_down)
                        ],
                      ),
                    )),
                Positioned(
                    right: 10,
                    child: Container(
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
                                        ? const Color.fromARGB(
                                            255, 190, 190, 190)
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
                    )),
              ],
            ),
          ),
        ));
  }
}
