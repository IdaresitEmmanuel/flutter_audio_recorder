import 'package:flutter/rendering.dart';

class AppColors {
  static const primary = Color(0xffFF6584);
  static const secondary = Color(0xff6C63FF);

  static const textPrimary = Color(0xff1F2937);
  static const textSecondary = Color(0xff6B7280);

  static const grey50 = Color(0xffF9FAFB);
  static const grey100 = Color(0xffF2F3F5);
  static const grey200 = Color(0xffE5E7EB);
  static const grey300 = Color(0xffD1D5DB);
  static const grey400 = Color(0xff9CA3AF);
  static const grey500 = Color(0xff6B7280);
  static const grey600 = Color(0xff4B5563);
  static const grey700 = Color(0xff374151);
  static const grey800 = Color(0xff1F2937);
  static const grey900 = Color(0xff111827);

  static const gradient = LinearGradient(
    colors: [Color(0xffFF6584), Color(0xff6C63FF)],
    stops: [0, .68],
  );
}
