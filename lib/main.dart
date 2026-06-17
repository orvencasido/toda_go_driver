<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/welcome_screen.dart';

void main() {
  // Optimization: Setting system UI overlay style for a more native feel
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF000080);
    const Color scaffoldBg = Color(0xFFF8F9FA);

    return MaterialApp(
      title: 'Toda GO',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryBlue,
          primary: primaryBlue,
          surface: Colors.white,
          background: scaffoldBg,
        ),
        
        // Global Typography
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
        
        // Modern Component Themes
        appBarTheme: AppBarTheme(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryBlue,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            textStyle: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[50],
          contentPadding: const EdgeInsets.all(16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey[200]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey[200]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: primaryBlue, width: 1.5),
          ),
        ),
      ),
      home: const WelcomeScreen(),
    );
  }
}
=======
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

>>>>>>> 9d63913 (Initial commit from Antigravity project)
