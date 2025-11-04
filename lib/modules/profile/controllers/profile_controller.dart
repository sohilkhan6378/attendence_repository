import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/storage_service.dart';
import '../../attendance/models/attendance_models.dart';

/// ProfileController भाषा, थीम व बायोमेट्रिक स्टेट मैनेज करता है।
class ProfileController extends GetxController {
  ProfileController(this._storageService);

  final StorageService _storageService;
  final Rx<EmployeeModel?> _employee = Rx<EmployeeModel?>(null);

  EmployeeModel? get employee => _employee.value;

  @override
  void onInit() {
    super.onInit();
    final employees = _storageService.readEmployees();
    if (employees.isNotEmpty) {
      _employee.value = employees.first;
      _applyPreferences(employees.first);
    }
  }

  void _applyPreferences(EmployeeModel employee) {
    if (employee.themeMode == 'dark') {
      Get.changeThemeMode(ThemeMode.dark);
    } else if (employee.themeMode == 'light') {
      Get.changeThemeMode(ThemeMode.light);
    }
    final parts = employee.languageCode.split('_');
    if (parts.length == 2) {
      Get.updateLocale(Locale(parts.first, parts.last));
    }
  }

  Future<void> updateTheme(String mode) async {
    if (_employee.value == null) return;
    Get.changeThemeMode(
      mode == 'dark'
          ? ThemeMode.dark
          : mode == 'light'
              ? ThemeMode.light
              : ThemeMode.system,
    );
    await _persist(_employee.value!.copyWith(themeMode: mode));
  }

  Future<void> updateLanguage(String localeCode) async {
    if (_employee.value == null) return;
    final parts = localeCode.split('_');
    if (parts.length == 2) {
      Get.updateLocale(Locale(parts.first, parts.last));
    }
    await _persist(_employee.value!.copyWith(languageCode: localeCode));
  }

  Future<void> markFaceEnrollment(bool value) async {
    if (_employee.value == null) return;
    await _persist(_employee.value!.copyWith(faceEnrolled: value));
  }

  Future<void> markFingerprintEnrollment(bool value) async {
    if (_employee.value == null) return;
    await _persist(_employee.value!.copyWith(fingerprintEnrolled: value));
  }

  Future<void> _persist(EmployeeModel updated) async {
    final employees = _storageService.readEmployees();
    final index = employees.indexWhere((e) => e.id == updated.id);
    if (index != -1) {
      employees[index] = updated;
      await _storageService.writeEmployees(employees);
      _employee.value = updated;
    }
  }
}
