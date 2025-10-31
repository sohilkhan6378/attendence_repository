import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// इंटर तथा रोबोटो आधारित टेक्स्ट थीम कॉन्फ़िगरेशन।
TextTheme buildTextTheme(ColorScheme colorScheme) {
  final base = GoogleFonts.interTextTheme();
  return base.copyWith(
    displayLarge: base.displayLarge?.copyWith(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      color: colorScheme.onSurface,
    ),
    displayMedium: base.displayMedium?.copyWith(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: colorScheme.onSurface,
    ),
    displaySmall: base.displaySmall?.copyWith(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: colorScheme.onSurface,
    ),
    bodyLarge: base.bodyLarge?.copyWith(
      fontSize: 16,
      color: colorScheme.onSurface,
    ),
    bodyMedium: base.bodyMedium?.copyWith(
      fontSize: 14,
      color: colorScheme.onSurface.withOpacity(0.9),
    ),
    bodySmall: base.bodySmall?.copyWith(
      fontSize: 12,
      color: colorScheme.onSurface.withOpacity(0.7),
    ),
    labelLarge: base.labelLarge?.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: colorScheme.onPrimary,
    ),
  );
}
