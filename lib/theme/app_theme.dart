import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF00B4D8);
  static const Color primaryDark = Color(0xFF0077B6);
  static const Color primaryLight = Color(0xFF90E0EF);
  
  // Accent Colors
  static const Color accent = Color(0xFF48CAE4);
  static const Color secondary = Color(0xFF0096C7);
  
  // Background Colors
  static const Color background = Color(0xFF03045E);
  static const Color surface = Color(0xFF023E8A);
  static const Color card = Color(0xAA1A237E);
  
  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFE0E0E0);
  static const Color textHint = Color(0xFF9E9E9E);
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF2196F3);
  
  // Gradient Colors
  static const Gradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );
  
  static const Gradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF023E8A), Color(0xFF03045E)],
  );
}

class AppTheme {
  static ThemeData get lightTheme {
    // Define text styles
    const TextStyle headline1 = TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontFamily: 'Poppins',
    );
    
    const TextStyle headline2 = TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      color: Colors.white,
      fontFamily: 'Poppins',
    );
    
    const TextStyle subtitle1 = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AppColors.textSecondary,
      fontFamily: 'Poppins',
    );
    
    const TextStyle bodyText1 = TextStyle(
      fontSize: 14,
      color: AppColors.textSecondary,
      fontFamily: 'Poppins',
    );
    
    const TextStyle button = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.white,
      fontFamily: 'Poppins',
    );

    return ThemeData(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        background: AppColors.background,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onBackground: Colors.white,
        error: AppColors.error,
        onError: Colors.white,
        brightness: Brightness.dark,
      ),
      
      // Text Themes
      textTheme: TextTheme(
        displayLarge: headline1,
        displayMedium: headline2,
        displaySmall: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          fontFamily: 'Poppins',
        ),
        headlineMedium: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          fontFamily: 'Poppins',
        ),
        headlineSmall: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.white,
          fontFamily: 'Poppins',
        ),
        titleLarge: headline2.copyWith(fontSize: 20),
        titleMedium: subtitle1,
        bodyLarge: bodyText1.copyWith(fontSize: 16),
        bodyMedium: bodyText1,
        bodySmall: const TextStyle(
          fontSize: 12,
          color: AppColors.textHint,
          fontFamily: 'Poppins',
        ),
        labelLarge: button,
      ),
      
      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          fontFamily: 'Poppins',
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      
      // Card Theme
      cardTheme: CardTheme(
        color: AppColors.card,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: button,
        ),
      ),
      
      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: button.copyWith(color: AppColors.primary),
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        hintStyle: const TextStyle(color: AppColors.textHint),
        labelStyle: const TextStyle(color: AppColors.textSecondary),
      ),
      
      // Icon Theme
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      
      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: Colors.white24,
        thickness: 0.5,
        space: 1,
      ),
      
      useMaterial3: true,
    );
  }
}
