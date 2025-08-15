import 'package:audiorecorder/core/presentation/app/echo_app.dart';
import 'package:audiorecorder/service_locator.dart';
import 'package:flutter/material.dart';

void main() async {
  await initDependencies();
  runApp(const EchoApp());
}
