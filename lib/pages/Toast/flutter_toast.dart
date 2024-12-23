import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

void showSuccessToast({
  required String msg,
}) {
  {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color.fromARGB(209, 0, 0, 0),
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
