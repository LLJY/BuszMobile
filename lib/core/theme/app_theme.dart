/// App theme for BuszMobile.
///
/// Provides light and dark Material 3 themes with dynamic color from a
/// cyan seed. Uses Inter as the primary typeface via google_fonts.
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// =============================================================================
// Spacing Constants
// =============================================================================

/// Consistent spacing tokens used across the app.
class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double s = 8;
  static const double m = 12;
  static const double l = 16;
  static const double xl = 24;
  static const double xxl = 32;
}

// =============================================================================
// Theme
// =============================================================================

class AppTheme {
  AppTheme._();

  static const _seed = Color(0xFF00BCD4);

  // ---------------------------------------------------------------------------
  // Public theme accessors
  // ---------------------------------------------------------------------------

  static ThemeData get lightTheme => _buildTheme(Brightness.light);
  static ThemeData get darkTheme => _buildTheme(Brightness.dark);

  // ---------------------------------------------------------------------------
  // Custom text theme (Inter, M3 type scale)
  // ---------------------------------------------------------------------------

  static TextTheme get _customTextTheme {
    return GoogleFonts.interTextTheme(
      const TextTheme(
        displayLarge: TextStyle(
          fontSize: 57,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.25,
        ),
        displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w400),
        displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.w400),
        headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w400),
        headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w400),
        headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
        titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Builder
  // ---------------------------------------------------------------------------

  static ThemeData _buildTheme(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: brightness,
      dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
    );

    // Use ThemeData(colorScheme: ...) which is the modern M3 way
    // and automatically sets up the right defaults for the whole theme.
    final base = ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      textTheme: _customTextTheme,
    );

    return base.copyWith(
      appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
        color: colorScheme.surfaceContainerLow,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Utilities
  // ---------------------------------------------------------------------------

  /// Parse a hex color string (e.g., "#FF5722") to a Color.
  static Color parseHexColor(String hex) {
    final cleaned = hex.replaceAll('#', '');
    if (cleaned.length == 6) {
      return Color(int.parse('FF$cleaned', radix: 16));
    }
    if (cleaned.length == 8) {
      return Color(int.parse(cleaned, radix: 16));
    }
    return Colors.grey;
  }
}
