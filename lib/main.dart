import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toda_go_driver/core/constants/app_colors.dart';
import 'package:toda_go_driver/features/dashboard/providers/profile_provider.dart';
import 'package:toda_go_driver/features/welcome/screens/splash_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      child: const TodaGoApp(),
      create: (_) => ProfileProvider()..fetchProfile(),
    ),
  );
}

class TodaGoApp extends StatelessWidget {
  const TodaGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android;

    final elevatedOverlayResolver = WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.disabled)) {
        return null;
      }
      if (states.contains(WidgetState.pressed)) {
        return Colors.white.withValues(alpha: 0.12);
      }
      if (states.contains(WidgetState.hovered) || states.contains(WidgetState.focused)) {
        if (isMobile) {
          return Colors.transparent;
        }
        return Colors.white.withValues(alpha: 0.08);
      }
      return null;
    });

    final defaultOverlayResolver = WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.disabled)) {
        return null;
      }
      if (states.contains(WidgetState.pressed)) {
        return AppColors.primaryNavy.withValues(alpha: 0.12);
      }
      if (states.contains(WidgetState.hovered) || states.contains(WidgetState.focused)) {
        if (isMobile) {
          return Colors.transparent;
        }
        return AppColors.primaryNavy.withValues(alpha: 0.08);
      }
      return null;
    });

    return MaterialApp(
      title: 'TODA GO',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: AppColors.primaryNavy,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryNavy,
          primary: AppColors.primaryNavy,
          secondary: AppColors.onlineGreen,
          onSurface: AppColors.primaryNavy,
        ),
        scaffoldBackgroundColor: AppColors.canvasBackground,
        fontFamily: 'Poppins',
        hoverColor: isMobile ? Colors.transparent : AppColors.primaryNavy.withValues(alpha: 0.08),
        focusColor: isMobile ? Colors.transparent : AppColors.primaryNavy.withValues(alpha: 0.08),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(overlayColor: elevatedOverlayResolver),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(overlayColor: defaultOverlayResolver),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(overlayColor: defaultOverlayResolver),
        ),
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(overlayColor: defaultOverlayResolver),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

