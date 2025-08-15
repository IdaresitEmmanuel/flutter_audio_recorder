import 'package:audiorecorder/core/presentation/router/routes.dart';
import 'package:audiorecorder/core/presentation/theme/theme.dart';
import 'package:flutter/material.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class EchoApp extends StatelessWidget {
  const EchoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      title: 'Record on Echo',
      theme: AppTheme.lightTheme,
      onGenerateRoute: Routes.onGenerateRoute,
    );
  }
}
