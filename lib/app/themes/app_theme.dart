import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DesignTokens extends ThemeExtension<DesignTokens> {
  const DesignTokens({required this.color, required this.spacing});

  final DesignColorTokens color;
  final DesignSpacingTokens spacing;

  static DesignTokens of(BuildContext context) {
    return Theme.of(context).extension<DesignTokens>() ?? light;
  }

  static const DesignTokens light = DesignTokens(
    color: DesignColorTokens(
      primary: Color(0xFF2B6CB0),
      onPrimary: Colors.white,
      secondary: Color(0xFF00A389),
      onSecondary: Colors.white,
      warning: Color(0xFFFFB020),
      success: Color(0xFF2FB344),
      error: Color(0xFFE04444),
      info: Color(0xFF3B82F6),
      surface: Color(0xFFF8FAFC),
      onSurface: Color(0xFF0F172A),
      muted: Color(0xFF64748B),
      divider: Color(0xFFE2E8F0),
    ),
    spacing: DesignSpacingTokens(base: 8),
  );

  static const DesignTokens dark = DesignTokens(
    color: DesignColorTokens(
      primary: Color(0xFF93C5FD),
      onPrimary: Color(0xFF0B1120),
      secondary: Color(0xFF34D399),
      onSecondary: Color(0xFF022C22),
      warning: Color(0xFFFACC15),
      success: Color(0xFF4ADE80),
      error: Color(0xFFF87171),
      info: Color(0xFF60A5FA),
      surface: Color(0xFF0F172A),
      onSurface: Color(0xFFF1F5F9),
      muted: Color(0xFF94A3B8),
      divider: Color(0xFF1E293B),
    ),
    spacing: DesignSpacingTokens(base: 8),
  );

  @override
  ThemeExtension<DesignTokens> copyWith({
    DesignColorTokens? color,
    DesignSpacingTokens? spacing,
  }) {
    return DesignTokens(
      color: color ?? this.color,
      spacing: spacing ?? this.spacing,
    );
  }

  @override
  ThemeExtension<DesignTokens> lerp(ThemeExtension<DesignTokens>? other, double t) {
    if (other is! DesignTokens) {
      return this;
    }
    return DesignTokens(
      color: DesignColorTokens(
        primary: Color.lerp(color.primary, other.color.primary, t)!,
        onPrimary: Color.lerp(color.onPrimary, other.color.onPrimary, t)!,
        secondary: Color.lerp(color.secondary, other.color.secondary, t)!,
        onSecondary: Color.lerp(color.onSecondary, other.color.onSecondary, t)!,
        warning: Color.lerp(color.warning, other.color.warning, t)!,
        success: Color.lerp(color.success, other.color.success, t)!,
        error: Color.lerp(color.error, other.color.error, t)!,
        info: Color.lerp(color.info, other.color.info, t)!,
        surface: Color.lerp(color.surface, other.color.surface, t)!,
        onSurface: Color.lerp(color.onSurface, other.color.onSurface, t)!,
        muted: Color.lerp(color.muted, other.color.muted, t)!,
        divider: Color.lerp(color.divider, other.color.divider, t)!,
      ),
      spacing: spacing,
    );
  }
}

class DesignColorTokens {
  const DesignColorTokens({
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.warning,
    required this.success,
    required this.error,
    required this.info,
    required this.surface,
    required this.onSurface,
    required this.muted,
    required this.divider,
  });

  final Color primary;
  final Color onPrimary;
  final Color secondary;
  final Color onSecondary;
  final Color warning;
  final Color success;
  final Color error;
  final Color info;
  final Color surface;
  final Color onSurface;
  final Color muted;
  final Color divider;
}

class DesignSpacingTokens {
  const DesignSpacingTokens({required this.base});

  final double base;

  double step(int multiplier) => base * multiplier;
}

class AppTheme {
  static ThemeData get light {
    final base = ThemeData.light(useMaterial3: true);
    final colorScheme = ColorScheme.fromSeed(
      seedColor: DesignTokens.light.color.primary,
      primary: DesignTokens.light.color.primary,
      secondary: DesignTokens.light.color.secondary,
      brightness: Brightness.light,
    );
    return base.copyWith(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: DesignTokens.light.color.surface,
      textTheme: _textTheme(Brightness.light),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: Colors.white,
        selectedColor: DesignTokens.light.color.primary.withOpacity(.12),
        labelStyle: base.textTheme.bodyMedium,
      ),
      cardTheme: const CardTheme(
        surfaceTintColor: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: DesignTokens.light.color.onSurface,
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      extensions: const [DesignTokens.light],
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: DesignTokens.light.color.primary,
        unselectedItemColor: DesignTokens.light.color.muted,
        showUnselectedLabels: true,
      ),
    );
  }

  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);
    final colorScheme = ColorScheme.fromSeed(
      seedColor: DesignTokens.dark.color.primary,
      primary: DesignTokens.dark.color.primary,
      secondary: DesignTokens.dark.color.secondary,
      brightness: Brightness.dark,
    );
    return base.copyWith(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: DesignTokens.dark.color.surface,
      textTheme: _textTheme(Brightness.dark),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: DesignTokens.dark.color.surface,
        selectedColor: DesignTokens.dark.color.primary.withOpacity(.18),
        labelStyle: base.textTheme.bodyMedium,
      ),
      cardTheme: CardTheme(
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        color: DesignTokens.dark.color.surface.withOpacity(.6),
        margin: EdgeInsets.zero,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: DesignTokens.dark.color.surface,
        foregroundColor: DesignTokens.dark.color.onSurface,
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      extensions: const [DesignTokens.dark],
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: DesignTokens.dark.color.primary,
        unselectedItemColor: DesignTokens.dark.color.muted,
        showUnselectedLabels: true,
      ),
    );
  }

  static TextTheme _textTheme(Brightness brightness) {
    final base = brightness == Brightness.light ? ThemeData.light().textTheme : ThemeData.dark().textTheme;
    final color = brightness == Brightness.light ? DesignTokens.light.color.onSurface : DesignTokens.dark.color.onSurface;
    return GoogleFonts.interTextTheme(base).copyWith(
      displaySmall: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w700, color: color),
      headlineSmall: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w600, color: color),
      titleLarge: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: color),
      titleMedium: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: color),
      bodyLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400, color: color),
      bodyMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: color),
      bodySmall: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400, color: color.withOpacity(.8)),
      labelMedium: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: color.withOpacity(.9)),
    );
  }
}
