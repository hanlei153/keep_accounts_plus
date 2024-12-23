import 'package:flutter/material.dart';

class BuildCheckClass extends StatefulWidget {
  final Map<String, IconData> checkClass;
  final String selectedValue;
  final ValueChanged<String> onSelected;
  const BuildCheckClass({
    Key? key,
    required this.selectedValue,
    required this.checkClass,
    required this.onSelected,
  }) : super(key: key);
  @override
  State<BuildCheckClass> createState() => _BuildCheckClassState();
}

class _BuildCheckClassState extends State<BuildCheckClass> {
  List<bool> selectedItems = [];

  @override
  void initState() {
    super.initState();
    // 初始化选中状态列表
    selectedItems = List.generate(widget.checkClass.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    // 确保 selectedItems 已经初始化好
    if (selectedItems.isEmpty) {
      return const CircularProgressIndicator(); // 或者显示其他等待组件
    }
    // 账单类型
    return Expanded(
      child: GridView.count(
        padding: const EdgeInsets.only(left: 20, right: 20),
        crossAxisCount: 4,
        children: List.generate(widget.checkClass.length, (index) {
          String key = widget.checkClass.keys.elementAt(index);
          IconData value = widget.checkClass[key]!;
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    // 单选逻辑：点击一个图标时，重置其他图标为未选中状态
                    for (int i = 0; i < selectedItems.length; i++) {
                      selectedItems[i] = (i == index); // 只有点击的图标选中
                    }
                    widget.onSelected(key);
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: selectedItems[index]
                        ? Theme.of(context).colorScheme.primary
                        : const Color.fromARGB(255, 212, 212, 212),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    value,
                    size: 30,
                    color: const Color.fromARGB(255, 88, 88, 88),
                  ),
                ),
              ),
              Text(key),
            ],
          );
        }),
      ),
    );
  }
}
