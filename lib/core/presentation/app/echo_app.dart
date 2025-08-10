import 'package:audiorecorder/core/presentation/router/routes.dart';
import 'package:audiorecorder/core/presentation/theme/theme.dart';
import 'package:flutter/material.dart';

class EchoApp extends StatelessWidget {
  const EchoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Record on Echo',
      theme: AppTheme.lightTheme,
      onGenerateRoute: Routes.onGenerateRoute,
    );
  }
}
