import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// ThemeController ऐप की थीम को लाइट/डार्क के बीच स्विच करता है।
class ThemeController extends GetxController {
  /// वर्तमान थीम मोड।
  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  /// यूज़र द्वारा चुने गये मोड के आधार पर थीम सेट करता है।
  void updateTheme(ThemeMode mode) {
    themeMode.value = mode;
  }
}
