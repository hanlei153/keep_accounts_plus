import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class DatePicker {
  /// 返回用户选择的年份和月份，以 [int] 元组形式返回：`(year, month)`。
  static Future<(int, int)> show(BuildContext context, int selectedyear,
      int selectedmonth, String title) async {
    int _selectedYear = selectedyear;
    int _selectedMonth = selectedmonth;
    String _title = title;
    bool isConfirm = false;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      barrierColor: Colors.black45, // 背景颜色
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.black12, // 边框颜色
              width: 1, // 边框宽度
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10), // 左上角半径
              topRight: Radius.circular(10), // 右上角半径
            ),
          ),
          height: MediaQuery.of(context).size.height * 0.3,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Text('取消')),
                    Text(_title),
                    GestureDetector(
                      onTap: () {
                        isConfirm = true;
                        Navigator.pop(context);
                      },
                      child: const Text('确定'),
                    ),
                  ],
                ),
              ),
              const Divider(
                color: Color.fromARGB(255, 221, 221, 221), // 分割线颜色
                height: 1, // 分割线高度
                thickness: 1, // 分割线的厚度
                indent: 1, // 分割线左侧的空白
                endIndent: 1, // 分割线右侧的空白
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: CupertinoPicker(
                          onSelectedItemChanged: (int index) {
                            _selectedYear = 2000 + index;
                          },
                          scrollController: FixedExtentScrollController(
                            initialItem: _selectedYear - 2000,
                          ),
                          itemExtent: 40,
                          children: List<Widget>.generate(500, (index) {
                            return Center(
                              child: Text('${2000 + index}'),
                            );
                          }),
                        ),
                      ),
                      Flexible(
                        child: CupertinoPicker(
                          onSelectedItemChanged: (int index) {
                            _selectedMonth = index + 1;
                          },
                          scrollController: FixedExtentScrollController(
                            initialItem: _selectedMonth - 1,
                          ),
                          itemExtent: 40,
                          children: List<Widget>.generate(12, (index) {
                            return Center(
                              child: Text('${1 + index}'),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    // 返回用户选择的年份和月份
    if (!isConfirm) {
      return (0, 0);
    } else {
      return (_selectedYear, _selectedMonth);
    }
  }
}
