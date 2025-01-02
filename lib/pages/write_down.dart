import 'package:flutter/material.dart';

import 'Widgets/build_check_class.dart';
import '../sqflite/database_helper.dart';
import 'Widgets/dialog/alert_dialog.dart';
import 'Toast/flutter_toast.dart';

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

  final Map<String, Widget> income = {
    '工资': Image.asset(width: 30, 'assets/icon/income_disburse/salary-male.png'),
    '兼职': Image.asset(
        width: 30, 'assets/icon/income_disburse/flyer-distributor-male.png'),
    '理财': Image.asset(
        width: 30, 'assets/icon/income_disburse/money-circulation.png'),
    '礼金': Image.asset(width: 30, 'assets/icon/income_disburse/gift.png'),
    '其他': Image.asset(width: 30, 'assets/icon/income_disburse/view-more.png'),
  };

  final Map<String, Widget> disburse = {
    '餐饮':
        Image.asset(width: 30, 'assets/icon/income_disburse/local_dining.png'),
    '水果': Image.asset(width: 30, 'assets/icon/income_disburse/fruit.png'),
    '购物': Image.asset(width: 30, 'assets/icon/income_disburse/shopping.png'),
    '交通': Image.asset(width: 30, 'assets/icon/income_disburse/car.png'),
    '娱乐': Image.asset(width: 30, 'assets/icon/income_disburse/party.png'),
    '住房': Image.asset(width: 30, 'assets/icon/income_disburse/house.png'),
    '社交': Image.asset(width: 30, 'assets/icon/income_disburse/group.png'),
    '旅行': Image.asset(width: 30, 'assets/icon/income_disburse/traveler.png'),
    '宠物': Image.asset(width: 30, 'assets/icon/income_disburse/pets.png'),
    '医疗': Image.asset(width: 30, 'assets/icon/income_disburse/treatment.png'),
    '服饰': Image.asset(width: 30, 'assets/icon/income_disburse/clothes.png'),
    '其他': Image.asset(width: 30, 'assets/icon/income_disburse/view-more.png'),
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
    String note = _noteController.text == '' ? category : _noteController.text;

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
        showSuccessToast(msg: '完成');
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
