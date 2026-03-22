import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum StatusType { success, error, warning, info }

class StatusMessage {
  static void show(String message,
      {StatusType type = StatusType.info, int durationSeconds = 3}) {
    Color bgColor;
    switch (type) {
      case StatusType.success:
        bgColor = Colors.green.shade600;
        break;
      case StatusType.error:
        bgColor = Colors.red.shade600;
        break;
      case StatusType.warning:
        bgColor = Colors.orange.shade700;
        break;
      case StatusType.info:
        bgColor = Colors.blue.shade600;
        break;
    }

    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: bgColor,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  static void success(String message) =>
      show(message, type: StatusType.success);
  static void error(String message) => show(message, type: StatusType.error);
  static void warning(String message) =>
      show(message, type: StatusType.warning);
  static void info(String message) => show(message, type: StatusType.info);
}
