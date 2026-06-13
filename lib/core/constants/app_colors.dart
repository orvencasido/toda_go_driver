import 'package:flutter/material.dart';

class AppColors {
  // Prevent instantiation
  AppColors._();

  // Canvas background (app scaffold background)
  static const Color canvasBackground = Colors.white;

  // Primary / Navy blue — header backgrounds, metric circles, primary text
  static const Color primaryNavy = Color(0xFF000C7D);

  // Deep navy used for some legacy references
  static const Color deepNavy = Color(0xFF000C7D);

  // Bright blue — action buttons, "View all" links, Navigate button text
  static const Color accentBlue = Color(0xFF2563EB);

  // Accent and UI greens
  static const Color onlineGreen = Color(0xFF00B050);
  static const Color textGreen = Color(0xFF22C55E);

  // Accent and UI reds
  static const Color offlineRed = Color(0xFFE53935);

  // Neutral tones
  static const Color borderBlack = Colors.black;
  static const Color textDark = Color(0xFF000C7D);
  static const Color textLight = Color(0xFF000C7D);
  static const Color cardBackground = Colors.white;

  // Driver profile card light blue tint
  static const Color profileCardBg = Color(0xFFCFEAF7);
  static const Color greyBg = Color(0xFFF1F5F9);

  // Light blue button backgrounds (Navigate/Call in trips)
  static const Color lightBlueBtnBg = Color(0xFFEFF6FF);
}
