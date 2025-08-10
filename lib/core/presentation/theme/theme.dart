import 'package:audiorecorder/core/presentation/theme/colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    textTheme: _textTheme(),
    // fontFamily: 'Inter'
  );

  static TextTheme _textTheme() {
    final textPrimary = AppColors.textPrimary;
    return TextTheme(
      // Headline Semibold
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        letterSpacing: -3,
        color: textPrimary,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: -2,
        color: textPrimary,
      ),
      headlineSmall: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -1,
        color: textPrimary,
      ),
      // Body medium(default) and Regular
      bodyLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: textPrimary,
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textPrimary,
      ),
      bodySmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textPrimary,
      ),
      // Display
      displayLarge: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
    );
  }
}
