import 'package:flutter/material.dart';

/// Central theme configuration that drives the Talala gradient identity.
class AppTheme {
  static const _gradientStart = Color(0xFFF9F5FF);
  static const _gradientEnd = Color(0xFFEFE4FF);

  /// Light theme tailored for soft purple gradients.
  static ThemeData get light {
    final base = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5A2D82)),
      fontFamily: 'Roboto',
      useMaterial3: true,
    );

    return base.copyWith(
      scaffoldBackgroundColor: _gradientStart,
      cardTheme: base.cardTheme.copyWith(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        color: Colors.white.withValues(alpha: 0.95),
      ),
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        elevation: 0,
        systemOverlayStyle: ThemeData.light().appBarTheme.systemOverlayStyle,
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  /// Common gradient used by multiple widgets.
  static const gradient = LinearGradient(
    colors: [_gradientStart, _gradientEnd],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
