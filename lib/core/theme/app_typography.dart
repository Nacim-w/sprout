import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTypography {
  AppTypography._();

  static const String display = 'Quicksand';
  static const String body = 'Nunito';

  static TextTheme textTheme() {
    return const TextTheme(
      displayLarge: TextStyle(
        fontFamily: display,
        fontSize: 38,
        height: 1.05,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.6,
        color: AppColors.ink,
      ),
      displayMedium: TextStyle(
        fontFamily: display,
        fontSize: 30,
        height: 1.1,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
        color: AppColors.ink,
      ),
      headlineMedium: TextStyle(
        fontFamily: display,
        fontSize: 23,
        height: 1.15,
        fontWeight: FontWeight.w700,
        color: AppColors.ink,
      ),
      titleLarge: TextStyle(
        fontFamily: body,
        fontSize: 19,
        height: 1.2,
        fontWeight: FontWeight.w800,
        color: AppColors.ink,
      ),
      titleMedium: TextStyle(
        fontFamily: body,
        fontSize: 16,
        height: 1.25,
        fontWeight: FontWeight.w800,
        color: AppColors.ink,
      ),
      bodyLarge: TextStyle(
        fontFamily: body,
        fontSize: 16,
        height: 1.55,
        fontWeight: FontWeight.w500,
        color: AppColors.ink,
      ),
      bodyMedium: TextStyle(
        fontFamily: body,
        fontSize: 14,
        height: 1.5,
        fontWeight: FontWeight.w500,
        color: AppColors.inkSoft,
      ),
      labelLarge: TextStyle(
        fontFamily: body,
        fontSize: 13.5,
        height: 1.2,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.2,
        color: AppColors.ink,
      ),
      labelSmall: TextStyle(
        fontFamily: body,
        fontSize: 11.5,
        height: 1.2,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.2,
        color: AppColors.inkSoft,
      ),
    );
  }

  static const TextStyle eyebrow = TextStyle(
    fontFamily: body,
    fontSize: 11.5,
    fontWeight: FontWeight.w800,
    letterSpacing: 1.6,
    color: AppColors.leaf,
  );
}
