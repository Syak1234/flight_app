import 'package:flutter/material.dart';

abstract final class AppColors {
  static const primary = Color.fromARGB(255, 42, 117, 246);
  static const primaryLight = Color(0xFFEBF2FF);

  static const background = Color(0xFFE6EEFB);
  static const surface = Colors.white;
  static const white = Colors.white;
  static const black = Color(0xFF111827);

  static const textPrimary = Color(0xFF0D0C22);
  static const textSecondary = Color(0xFF94A3B8);
  static const textHighlight = Color.fromARGB(255, 42, 117, 246);
  static const textWhite = Colors.white;

  static const divider = Color(0xFFE5E7EB);
  static const border = Color(0xFFE5E7EB);
  static const shadow = Color(0x00000000);

  static const chipSelected = Color(0xFF3669C9);
  static const chipUnselected = Colors.white;

  static const backgroundGradient = [
    Color(0xFFDEEAFA), // Top (Light Blue)
    Color(0xFFF6FAFF), // Bottom (Subtler Blue)
    Color.fromARGB(255, 253, 253, 253), // Extension to White
    Color.fromARGB(255, 253, 253, 253),
  ];

  static const headerGradient = [
    Color(0xFF3669C9), // Top
    Color(0xFF254EDB), // Mid
    Color(0xFF1E3A8A), // Bottom
  ];

  static const airlineCitilink = Color(0xFF4CAF50);
}
