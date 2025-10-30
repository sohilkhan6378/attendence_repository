import 'package:flutter/material.dart';

class AppColorScheme {
  // Light Color Scheme (Material 3)
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,

    // Primary - #2B6CB0
    primary: Color(0xFF2B6CB0),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFD3E4FD),
    onPrimaryContainer: Color(0xFF001C3A),

    // Secondary - #00A389
    secondary: Color(0xFF00A389),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFB0F2E3),
    onSecondaryContainer: Color(0xFF00201A),

    // Tertiary/Accent - #FFB020
    tertiary: Color(0xFFFFB020),
    onTertiary: Color(0xFF000000),
    tertiaryContainer: Color(0xFFFFEDD5),
    onTertiaryContainer: Color(0xFF2D1600),

    // Error - #E04444
    error: Color(0xFFE04444),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFF9DEDC),
    onErrorContainer: Color(0xFF410E0B),

    // Background & Surface
    background: Color(0xFFF9FAFB),
    onBackground: Color(0xFF111827),
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF111827),
    surfaceVariant: Color(0xFFF3F4F6),
    onSurfaceVariant: Color(0xFF4B5563),

    // Outline
    outline: Color(0xFFD1D5DB),
    outlineVariant: Color(0xFFE5E7EB),

    // Other
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFF1F2937),
    onInverseSurface: Color(0xFFF9FAFB),
    inversePrimary: Color(0xFF90CAF9),
  );

  // Dark Color Scheme (Material 3)
  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,

    // Primary
    primary: Color(0xFF90CAF9),
    onPrimary: Color(0xFF0D3C61),
    primaryContainer: Color(0xFF2B6CB0),
    onPrimaryContainer: Color(0xFFD3E4FD),

    // Secondary
    secondary: Color(0xFF80DED3),
    onSecondary: Color(0xFF004D40),
    secondaryContainer: Color(0xFF00695C),
    onSecondaryContainer: Color(0xFFB0F2E3),

    // Tertiary/Accent
    tertiary: Color(0xFFFFB020),
    onTertiary: Color(0xFF2D1600),
    tertiaryContainer: Color(0xFF8B5000),
    onTertiaryContainer: Color(0xFFFFEDD5),

    // Error
    error: Color(0xFFEF9A9A),
    onError: Color(0xFFB71C1C),
    errorContainer: Color(0xFFC62828),
    onErrorContainer: Color(0xFFF9DEDC),

    // Background & Surface
    background: Color(0xFF111827),
    onBackground: Color(0xFFF9FAFB),
    surface: Color(0xFF1F2937),
    onSurface: Color(0xFFF9FAFB),
    surfaceVariant: Color(0xFF374151),
    onSurfaceVariant: Color(0xFFD1D5DB),

    // Outline
    outline: Color(0xFF4B5563),
    outlineVariant: Color(0xFF374151),

    // Other
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFFF9FAFB),
    onInverseSurface: Color(0xFF111827),
    inversePrimary: Color(0xFF2B6CB0),
  );

  // Additional Semantic Colors
  static const Color success = Color(0xFF2FB344);
  static const Color successDark = Color(0xFF4CAF50);

  static const Color info = Color(0xFF3B82F6);
  static const Color infoDark = Color(0xFF64B5F6);

  static const Color warning = Color(0xFFFFB020);
  static const Color warningDark = Color(0xFFFFCA28);

  // Gray Scale
  static const Color gray50 = Color(0xFFF9FAFB);
  static const Color gray100 = Color(0xFFF3F4F6);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray300 = Color(0xFFD1D5DB);
  static const Color gray400 = Color(0xFF9CA3AF);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color gray600 = Color(0xFF4B5563);
  static const Color gray700 = Color(0xFF374151);
  static const Color gray800 = Color(0xFF1F2937);
  static const Color gray900 = Color(0xFF111827);
}
