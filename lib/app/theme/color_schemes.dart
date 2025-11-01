import 'package:flutter/material.dart';

/// लाइट थीम के लिए प्राथमिक कलर स्कीम।
const ColorScheme lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF2B6CB0),
  onPrimary: Colors.white,
  secondary: Color(0xFF00A389),
  onSecondary: Colors.white,
  tertiary: Color(0xFFFFB020),
  onTertiary: Colors.black,
  error: Color(0xFFE04444),
  onError: Colors.white,
  surface: Color(0xFFF6F8FB),
  onSurface: Color(0xFF1F2937),
  outline: Color(0xFFCBD5F5),
  shadow: Colors.black12,
  surfaceTint: Color(0xFF2B6CB0),
);

/// डार्क थीम के लिए प्राथमिक कलर स्कीम।
const ColorScheme darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF7CB5FF),
  onPrimary: Color(0xFF0C1A2E),
  secondary: Color(0xFF33D1BA),
  onSecondary: Color(0xFF003B31),
  tertiary: Color(0xFFFFCE73),
  onTertiary: Color(0xFF3F2A00),
  error: Color(0xFFFF7A7A),
  onError: Color(0xFF370000),
  surface: Color(0xFF111827),
  onSurface: Color(0xFFE5E7EB),
  outline: Color(0xFF334155),
  shadow: Colors.black54,
  surfaceTint: Color(0xFF7CB5FF),
);
