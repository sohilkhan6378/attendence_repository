import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'color_scheme.dart';
import 'text_theme.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: AppColorScheme.lightColorScheme,
      textTheme: AppTextTheme.textTheme,

      // App Bar Theme
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: AppColorScheme.lightColorScheme.surface,
        foregroundColor: AppColorScheme.lightColorScheme.onSurface,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        titleTextStyle: AppTextTheme.textTheme.headlineMedium?.copyWith(
          color: AppColorScheme.lightColorScheme.onSurface,
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: AppTextTheme.textTheme.labelLarge,
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          side: BorderSide(
            color: AppColorScheme.lightColorScheme.outline,
          ),
          textStyle: AppTextTheme.textTheme.labelLarge,
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          minimumSize: const Size(48, 40),
          textStyle: AppTextTheme.textTheme.labelLarge,
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColorScheme.lightColorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppColorScheme.lightColorScheme.outline,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppColorScheme.lightColorScheme.outline,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppColorScheme.lightColorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppColorScheme.lightColorScheme.error,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppColorScheme.lightColorScheme.error,
            width: 2,
          ),
        ),
        labelStyle: AppTextTheme.textTheme.bodyMedium?.copyWith(
          color: AppColorScheme.lightColorScheme.onSurfaceVariant,
        ),
        hintStyle: AppTextTheme.textTheme.bodyMedium?.copyWith(
          color: AppColorScheme.lightColorScheme.onSurfaceVariant,
        ),
      ),

      // Card Theme

      // Chip Theme
      chipTheme: ChipThemeData(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        labelPadding: const EdgeInsets.symmetric(horizontal: 4),
        backgroundColor: AppColorScheme.lightColorScheme.surfaceVariant,
        selectedColor: AppColorScheme.lightColorScheme.primaryContainer,
        disabledColor: AppColorScheme.gray200,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        labelStyle: AppTextTheme.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColorScheme.lightColorScheme.surface,
        selectedItemColor: AppColorScheme.lightColorScheme.primary,
        unselectedItemColor: AppColorScheme.lightColorScheme.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: AppTextTheme.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTextTheme.textTheme.bodySmall,
      ),

      // Dialog Theme

      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColorScheme.lightColorScheme.primary,
        foregroundColor: AppColorScheme.lightColorScheme.onPrimary,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: AppColorScheme.lightColorScheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),

      // Icon Theme
      iconTheme: IconThemeData(
        color: AppColorScheme.lightColorScheme.onSurfaceVariant,
        size: 24,
      ),

      // Scaffold Background
      scaffoldBackgroundColor: AppColorScheme.lightColorScheme.background,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: AppColorScheme.darkColorScheme,
      textTheme: AppTextTheme.textTheme,

      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: AppColorScheme.darkColorScheme.surface,
        foregroundColor: AppColorScheme.darkColorScheme.onSurface,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        titleTextStyle: AppTextTheme.textTheme.headlineMedium?.copyWith(
          color: AppColorScheme.darkColorScheme.onSurface,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: AppTextTheme.textTheme.labelLarge,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          side: BorderSide(
            color: AppColorScheme.darkColorScheme.outline,
          ),
          textStyle: AppTextTheme.textTheme.labelLarge,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColorScheme.darkColorScheme.surfaceVariant,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppColorScheme.darkColorScheme.outline,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppColorScheme.darkColorScheme.outline,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppColorScheme.darkColorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppColorScheme.darkColorScheme.error,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppColorScheme.darkColorScheme.error,
            width: 2,
          ),
        ),
        labelStyle: AppTextTheme.textTheme.bodyMedium?.copyWith(
          color: AppColorScheme.darkColorScheme.onSurfaceVariant,
        ),
        hintStyle: AppTextTheme.textTheme.bodyMedium?.copyWith(
          color: AppColorScheme.darkColorScheme.onSurfaceVariant,
        ),
      ),


      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColorScheme.darkColorScheme.surface,
        selectedItemColor: AppColorScheme.darkColorScheme.primary,
        unselectedItemColor: AppColorScheme.darkColorScheme.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: AppTextTheme.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTextTheme.textTheme.bodySmall,
      ),


      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColorScheme.darkColorScheme.primary,
        foregroundColor: AppColorScheme.darkColorScheme.onPrimary,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      dividerTheme: DividerThemeData(
        color: AppColorScheme.darkColorScheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),

      iconTheme: IconThemeData(
        color: AppColorScheme.darkColorScheme.onSurfaceVariant,
        size: 24,
      ),

      scaffoldBackgroundColor: AppColorScheme.darkColorScheme.background,
    );
  }
}
