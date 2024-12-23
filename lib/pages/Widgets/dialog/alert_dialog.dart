import 'package:flutter/material.dart';

void showCustomDialog(
    {required BuildContext context,
    required String title,
    required String content,
    String buttonText = '关闭'}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(buttonText),
          ),
        ],
      );
    },
  );
}

void showErrorDialog({
  required BuildContext context,
  required String title,
  required String content,
  String buttonText = '关闭',
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.red[200],
        title: Text(
          title,
        ),
        content: Text(
          content,
          // ,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(buttonText,
                style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
          ),
        ],
      );
    },
  );
}

void showWarningDialog({
  required BuildContext context,
  required String title,
  required String content,
  String buttonText = '关闭',
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          title,
          style: const TextStyle(color: Colors.orange), // 错误提示的标题颜色
        ),
        content: Text(
          content,
          style: const TextStyle(color: Colors.orange),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(buttonText,
                style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
          ),
        ],
      );
    },
  );
}
