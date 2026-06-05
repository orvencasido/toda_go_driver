import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toda_go_driver/core/constants/app_colors.dart';
import 'package:toda_go_driver/features/dashboard/providers/profile_provider.dart';
import 'package:toda_go_driver/features/welcome/screens/splash_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ProfileProvider()..fetchProfile(),
      child: const TodaGoApp(),
    ),
  );
}

class TodaGoApp extends StatelessWidget {
  const TodaGoApp({super.key});

  @override
  Widget build(BuildContext context) {
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
        ),
        scaffoldBackgroundColor: AppColors.lightBlueBackground,
        fontFamily: 'Poppins',
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

