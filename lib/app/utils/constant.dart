import 'package:flutter/material.dart';

class AppConstants {
  // App Info
  static const String appName = 'Attendance Management';
  static const String appVersion = '1.0.0';

  // Storage Keys
  static const String keyToken = 'auth_token';
  static const String keyUser = 'user_data';
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyThemeMode = 'theme_mode';
  static const String keyLanguage = 'language';

  // API Endpoints (Replace with your actual endpoints)
  static const String baseUrl = 'https://api.yourcompany.com/v1';
  static const String loginEndpoint = '/auth/login';
  static const String verifyOtpEndpoint = '/auth/verify-otp';
  static const String attendanceEndpoint = '/attendance';
  static const String requestsEndpoint = '/requests';
  static const String reportsEndpoint = '/reports';

  // Attendance Rules
  static const Duration lateCutoff = Duration(hours: 10, minutes: 30);
  static const Duration gracePeriod = Duration(minutes: 10);
  static const Duration autoCheckoutTime = Duration(hours: 20); // 8:00 PM
  static const double geoFenceRadius = 100.0; // meters

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 8.0;
  static const double cardRadius = 12.0;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 150);
  static const Duration mediumAnimation = Duration(milliseconds: 250);
  static const Duration longAnimation = Duration(milliseconds: 350);

  // Date Formats
  static const String dateFormat = 'dd MMM yyyy';
  static const String timeFormat = 'hh:mm a';
  static const String dateTimeFormat = 'dd MMM yyyy, hh:mm a';
  static const String fullDateFormat = 'EEEE, dd MMMM yyyy';
}

class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

class AppRadius {
  static const double sm = 4.0;
  static const double md = 8.0;
  static const double lg = 12.0;
  static const double xl = 16.0;
  static const double pill = 999.0;
}

class AppElevation {
  static const double level1 = 2.0;
  static const double level2 = 4.0;
  static const double level3 = 8.0;
  static const double level4 = 16.0;
}

class AppIcons {
  // You can define custom icon paths or use MaterialIcons
  static const IconData home = Icons.home_rounded;
  static const IconData calendar = Icons.calendar_month_rounded;
   static const IconData reports = Icons.bar_chart_rounded;
  static const IconData profile = Icons.person_rounded;
  static const IconData checkIn = Icons.login_rounded;
  static const IconData checkOut = Icons.logout_rounded;
  static const IconData breakStart = Icons.coffee_rounded;
  static const IconData breakEnd = Icons.play_arrow_rounded;
}
