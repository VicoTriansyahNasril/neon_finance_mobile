import 'package:flutter/material.dart';

class AppTheme {
  static const neonPurple = Color(0xFFBF40FF);
  static const neonCyan = Color(0xFF00F0FF);
  static const neonPink = Color(0xFFFF10F0);
  static const neonGreen = Color(0xFF39FF14);
  static const electricBlue = Color(0xFF0080FF);

  static const darkBg = Color(0xFF0A0A0F);
  static const cardBg = Color(0xFF1A1A2E);
  static const darkCard = Color(0xFF16162A);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBg,
      primaryColor: neonPurple,
      colorScheme: const ColorScheme.dark(
        primary: neonPurple,
        secondary: neonCyan,
        surface: cardBg,
        error: Colors.redAccent,
      ),
      cardTheme: const CardThemeData(
        color: cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white70),
        bodySmall: TextStyle(color: Colors.white54),
      ),
    );
  }
}
