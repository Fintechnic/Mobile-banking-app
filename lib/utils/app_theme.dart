import 'package:flutter/material.dart';

/// Centralized app theme configuration
class AppTheme {
  // Primary colors
  static const Color primaryColor = Color(0xFF1A3A6B);
  static const Color secondaryColor = Color(0xFF5A8ED0);
  static const Color backgroundColor = Color(0xFFF5F7FA);
  
  // Text colors
  static const Color textPrimaryColor = Color(0xFF333333);
  static const Color textSecondaryColor = Color(0xFF666666);
  static const Color textTertiaryColor = Color(0xFF999999);
  
  // Common gradient
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryColor, secondaryColor],
  );
  
  // Get the main ThemeData for the app
  static ThemeData getTheme() {
    return ThemeData(
      primaryColor: primaryColor,
      fontFamily: 'SF Pro Display',
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(fontSize: 16),
        bodyMedium: TextStyle(fontSize: 14),
        bodySmall: TextStyle(fontSize: 12),
      ),
    );
  }
  
  // Card decoration
  static BoxDecoration cardDecoration({double borderRadius = 10.0}) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
  
  // Error card decoration
  static BoxDecoration errorCardDecoration({double borderRadius = 10.0}) {
    return BoxDecoration(
      color: Colors.red.shade50,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: Colors.red.shade200),
    );
  }
} 