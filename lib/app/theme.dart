import 'package:flutter/material.dart';

abstract final class JungleTheme {
  static const deepJungle = Color(0xFF123D24);
  static const forest = Color(0xFF1F6B3A);
  static const leaf = Color(0xFF3E9B4F);
  static const brightLeaf = Color(0xFF69C75A);
  static const earth = Color(0xFF6B4527);
  static const soil = Color(0xFF3B2719);
  static const banana = Color(0xFFFFD447);
  static const gold = Color(0xFFF5B82E);
  static const sky = Color(0xFFBDE7A5);
  static const darkUi = Color(0xFF172016);

  static ThemeData build() {
    final scheme = ColorScheme.fromSeed(
      seedColor: forest,
      brightness: Brightness.dark,
      primary: banana,
      secondary: brightLeaf,
      surface: darkUi,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: deepJungle,
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 44,
          height: 0.96,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
        ),
        displayMedium: TextStyle(
          fontSize: 30,
          height: 1,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.8,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.6,
        ),
        titleMedium: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          height: 1.3,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          height: 1.3,
        ),
      ),
    );
  }

  static BoxDecoration glassPanel({Color? color}) => BoxDecoration(
    color: (color ?? darkUi).withValues(alpha: 0.78),
    borderRadius: BorderRadius.circular(22),
    border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
    boxShadow: const [
      BoxShadow(
        color: Color(0x55000000),
        blurRadius: 20,
        offset: Offset(0, 10),
      ),
    ],
  );
}
