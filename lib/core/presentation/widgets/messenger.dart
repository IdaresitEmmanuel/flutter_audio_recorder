import 'package:audiorecorder/core/presentation/app/echo_app.dart';
import 'package:flutter/material.dart';

class Messenger {
  static void showSnackBar(String text) {
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(content: Text(text)),
    );
  }
}
