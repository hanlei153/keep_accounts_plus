import 'package:flutter/material.dart';

import 'Widgets/build_check_class.dart';
import '../sqflite/database_helper.dart';
import 'Widgets/dialog/alert_dialog.dart';

class WriteDownPage extends StatefulWidget {
  @override
  State<WriteDownPage> createState() => _WriteDownPageState();
}

class _WriteDownPageState extends State<WriteDownPage> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final FocusNode _notefocusNode = FocusNode();

  String? selectedValue = '支出';
  String? checkClassKey = '';

  final Map<String, IconData> income = {
    '工资': Icons.work,
    '兼职': Icons.business_center,
    '理财': Icons.attach_money,
    '礼金': Icons.card_giftcard,
    '其他': Icons.more_horiz,
  };

  final Map<String, IconData> disburse = {
    '餐饮': Icons.local_dining,
    '水果': Icons.local_dining,
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // 记得销毁 FocusNode
    _focusNode.dispose();
    _notefocusNode.dispose();
    super.dispose();
  }

  // 获取输入框的文本和选择的icon类型
  void _getInputValue() async {
    double? amount = double.tryParse(_controller.text);
    String category = checkClassKey!;
    String type = selectedValue!;
    String date = DateTime.now().toIso8601String().substring(0, 10);
    String note = _noteController.text;

    if (amount == null || amount == 0) {
      showWarningDialog(context: context, title: '金额错误', content: '请输入正确的金额');
      return;
    } else if (category == '') {
      showWarningDialog(context: context, title: '分类错误', content: '请选择分类');
      return;
    } else {
      FocusScope.of(context).unfocus();
      await DatabaseHelper.instance.database.then((db) {
        db.insert('bills', {
          'amount': amount,
          'category': category,
          'type': type,
          'date': date,
          'note': note,
        });
        _controller.clear();
        _noteController.clear();
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    // appBar
    const TextStyle textStyle = TextStyle(
      fontSize: 20,
    );

    final appBarButton = Row(
      children: [
        const Spacer(),
        GestureDetector(
          onTap: () {
            setState(() {
              selectedValue = '支出';
            });
          },
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border(
                  bottom: selectedValue == '支出'
                      ? const BorderSide(width: 3)
                      : BorderSide.none),
            ),
            child: const Text(
              '支出',
              style: textStyle,
            ),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.15,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              selectedValue = '收入';
            });
          },
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border(
                  bottom: selectedValue == '收入'
                      ? const BorderSide(width: 3)
                      : BorderSide.none),
            ),
            child: const Text(
              '收入',
              style: textStyle,
            ),
          ),
        ),
        const Spacer(),
      ],
    );

    // 输入框
    final textField = Padding(
      padding: const EdgeInsets.only(left: 40, right: 40),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        style: const TextStyle(
          fontSize: 18,
        ),
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          hintText: '请输入金额',
          hintStyle: TextStyle(
            color: Colors.grey, // 提示文字颜色
            fontSize: 18, // 字体大小
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          prefixIcon: Icon(Icons.edit),
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 50.0),
          filled: true,
        ),
        onEditingComplete: () {
          // 完成输入后，切换焦点到下一个输入框
          FocusScope.of(context).requestFocus(_notefocusNode);
        },
      ),
    );

    // 备注输入框
    final noteField = Padding(
      padding: const EdgeInsets.only(left: 40, top: 5, right: 40),
      child: TextField(
        controller: _noteController,
        focusNode: _notefocusNode,
        style: const TextStyle(
          fontSize: 18,
        ),
        // keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          hintText: '备注',
          hintStyle: TextStyle(
            color: Colors.grey, // 提示文字颜色
            fontSize: 18, // 字体大小
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          prefixIcon: Icon(Icons.note),
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 50.0),
          filled: true,
        ),
        onEditingComplete: () {
          // 完成输入后，收起键盘或执行其他操作
          FocusScope.of(context).unfocus();
        },
      ),
    );

    // 按钮
    final button = ElevatedButton(
      onPressed: () => _getInputValue(),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: const Color.fromARGB(255, 225, 225, 225),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      ),
      child: const Text('记一笔'),
    );

    // 页面
    return GestureDetector(
      onTap: () {
        _focusNode.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: appBarButton,
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            BuildCheckClass(
              selectedValue: selectedValue!,
              checkClass: selectedValue == '支出' ? disburse : income,
              onSelected: (value) => setState(() {
                checkClassKey = value;
              }),
            ),
            const SizedBox(
              height: 20,
            ),
            textField,
            noteField,
            const SizedBox(
              height: 5,
            ),
            button,
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
