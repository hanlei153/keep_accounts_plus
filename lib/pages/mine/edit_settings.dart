import 'package:flutter/material.dart';
import 'package:keep_accounts_plus/pages/Widgets/dialog/alert_dialog.dart';
import '../../common/sharedppreferences.dart/sharedPreferences.dart';
import '../../pages/Toast/flutter_toast.dart';

class EditSettings extends StatefulWidget {
  final String title;
  final String contentText;
  const EditSettings(
      {super.key, required this.title, required this.contentText});
  @override
  State<EditSettings> createState() => _EditSettingsState();
}

class _EditSettingsState extends State<EditSettings> {
  final TextEditingController _controller = TextEditingController();
  final _foucsNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() async {
    if (_controller.text.isEmpty) {
      showCustomDialog(context: context, title: '提示', content: '不允许设置空白用户名');
    } else {
      setString('username', _controller.text);
      showSuccessToast(msg: '保存成功');
      await Future.delayed(const Duration(milliseconds: 800));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('设置'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 20, // 字体大小
              ),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: widget.contentText,
                hintStyle: const TextStyle(
                  color: Colors.grey, // 提示文字颜色
                  fontSize: 16, // 字体大小
                ),
              ),
              controller: _controller,
              focusNode: _foucsNode,
              maxLines: 1,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _save();
                  },
                  child: const Text('保存'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
