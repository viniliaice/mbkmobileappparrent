import 'package:flutter/material.dart';

class AuroraColors {
  AuroraColors._();

  // Aurora palette
  static const deepNavy = Color(0xFF0B1026);
  static const midnightBlue = Color(0xFF0F1B3D);
  static const darkIndigo = Color(0xFF1A2A5C);
  static const indigo = Color(0xFF3D5AFE);
  static const cyan = Color(0xFF00BCD4);
  static const emerald = Color(0xFF2ECC71);
  static const teal = Color(0xFF1ABC9C);
  static const softPurple = Color(0xFF9B59B6);
  static const lavender = Color(0xFFB39DDB);
  static const auroraGreen = Color(0xFF00E676);
  static const auroraBlue = Color(0xFF448AFF);
  static const lightCyan = Color(0xFF80DEEA);
  static const white = Color(0xFFFFFFFF);
  static const offWhite = Color(0xFFF0F4FF);
  static const darkSurface = Color(0xFF0D142E);
  static const cardDark = Color(0xFF141D3A);
  static const cardLight = Color(0xFFFFFFFF);

  // Gradient pairs
  static const auroraGradient1 = [Color(0xFF00E676), Color(0xFF448AFF)];
  static const auroraGradient2 = [Color(0xFF448AFF), Color(0xFF9B59B6)];
  static const auroraGradient3 = [Color(0xFF00BCD4), Color(0xFF3D5AFE)];
  static const auroraGradient4 = [Color(0xFFB39DDB), Color(0xFF80DEEA)];
  static const auroraGradient5 = [Color(0xFF1ABC9C), Color(0xFF2ECC71)];
}

ThemeData auroraLightTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF0F4FF),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF3D5AFE),
      secondary: Color(0xFF00BCD4),
      tertiary: Color(0xFF2ECC71),
      surface: Color(0xFFFFFFFF),
      surfaceTint: Color(0xFFF0F4FF),
      onPrimary: Color(0xFFFFFFFF),
      onSecondary: Color(0xFFFFFFFF),
      onSurface: Color(0xFF0B1026),
      onSurfaceVariant: Color(0xFF4A4F6A),
      outline: Color(0xFFD0D5E0),
      outlineVariant: Color(0xFFE8ECF4),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: Color(0xFF0B1026), letterSpacing: -0.5),
      displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Color(0xFF0B1026), letterSpacing: -0.25),
      headlineLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xFF0B1026)),
      headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF0B1026)),
      titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF0B1026)),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF0B1026)),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xFF1A1F36), height: 1.5),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xFF4A4F6A), height: 1.4),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF3D5AFE), letterSpacing: 0.5),
      labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF7A7F9E), letterSpacing: 0.5),
    ),
      cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      clipBehavior: Clip.antiAlias,
      color: Colors.white.withValues(alpha: 0.7),
    ),
    navigationBarTheme: const NavigationBarThemeData(
      height: 64,
      backgroundColor: Color(0xFFF0F4FF),
      indicatorColor: Color(0xFF3D5AFE),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.6),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: const Color(0xFFD0D5E0), width: 1)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF3D5AFE), width: 1.5)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    ),
  );
}

ThemeData auroraDarkTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF0B1026),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF448AFF),
      secondary: Color(0xFF80DEEA),
      tertiary: Color(0xFF00E676),
      surface: Color(0xFF0D142E),
      surfaceTint: Color(0xFF0B1026),
      onPrimary: Color(0xFFFFFFFF),
      onSecondary: Color(0xFF0B1026),
      onSurface: Color(0xFFF0F4FF),
      onSurfaceVariant: Color(0xFFA0A8C4),
      outline: Color(0xFF2A3050),
      outlineVariant: Color(0xFF1A2240),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: Color(0xFFF0F4FF), letterSpacing: -0.5),
      displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Color(0xFFF0F4FF), letterSpacing: -0.25),
      headlineLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xFFF0F4FF)),
      headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFFF0F4FF)),
      titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFFF0F4FF)),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFFF0F4FF)),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xFFD0D5E0), height: 1.5),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xFFA0A8C4), height: 1.4),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF448AFF), letterSpacing: 0.5),
      labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF6A72A0), letterSpacing: 0.5),
    ),
      cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      clipBehavior: Clip.antiAlias,
      color: const Color(0xFF141D3A).withValues(alpha: 0.6),
    ),
    navigationBarTheme: NavigationBarThemeData(
      height: 64,
      backgroundColor: const Color(0xFF0D142E).withValues(alpha: 0.8),
      indicatorColor: const Color(0xFF448AFF),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF141D3A).withValues(alpha: 0.6),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: const Color(0xFF2A3050), width: 1)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF448AFF), width: 1.5)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    ),
  );
}
