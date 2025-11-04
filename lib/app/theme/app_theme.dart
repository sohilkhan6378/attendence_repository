import 'package:flutter/material.dart';

import 'color_schemes.dart';
import 'text_theme.dart';

/// Material 3 आधारित थीम सेटअप जो लाइट और डार्क दोनों वेरिएंट उपलब्ध कराता है।
class AppTheme {
  AppTheme._();

  /// लाइट मोड थीम डाटा।
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
        textTheme: buildTextTheme(lightColorScheme),
        scaffoldBackgroundColor: lightColorScheme.surface,
        appBarTheme: AppBarTheme(
          backgroundColor: lightColorScheme.surface,
          foregroundColor: lightColorScheme.onSurface,
          elevation: 0,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: lightColorScheme.primary,
          contentTextStyle: TextStyle(
            color: lightColorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        chipTheme: ChipThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          labelStyle: TextStyle(
            color: lightColorScheme.onSurface,
          ),
        ),
      );

  /// डार्क मोड थीम डाटा।
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
        textTheme: buildTextTheme(darkColorScheme),
        scaffoldBackgroundColor: darkColorScheme.surface,
        appBarTheme: AppBarTheme(
          backgroundColor: darkColorScheme.surface,
          foregroundColor: darkColorScheme.onSurface,
          elevation: 0,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: darkColorScheme.primary,
          contentTextStyle: TextStyle(
            color: darkColorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        chipTheme: ChipThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          labelStyle: TextStyle(
            color: darkColorScheme.onSurface,
          ),
        ),
      );
}
