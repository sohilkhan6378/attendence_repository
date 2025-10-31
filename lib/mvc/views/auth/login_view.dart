import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/theme_controller.dart';
import '../../controllers/employee_controller.dart';
import '../dashboard/dashboard_view.dart';
import '../widgets/gradient_background.dart';
import '../widgets/primary_button.dart';

/// LoginView एडमिन उपयोगकर्ता को सुरक्षित लॉगिन इंटरफ़ेस प्रदान करती है।
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController(text: 'admin@pulsetime.app');
  final TextEditingController _passwordController = TextEditingController(text: 'Pulse@123');
  bool _obscurePassword = true;

  AuthController get _authController => Get.find<AuthController>();
  ThemeController get _themeController => Get.find<ThemeController>();
  EmployeeController get _employeeController => Get.find<EmployeeController>();

  /// ईमेल व पासवर्ड को validate करके लॉगिन करने वाली विधि।
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final bool success = await _authController.login(
      email: _emailController.text,
      password: _passwordController.text,
    );
    if (success) {
      // कर्मचारियों को सुनिश्चित रूप से लोड करें।
      _employeeController.loadEmployees();
      if (!mounted) return;
      Get.offAll(() => const DashboardView());
    } else {
      Get.snackbar(
        'लॉगिन विफल',
        'कृपया सही एडमिन क्रेडेंशियल दर्ज करें।',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Card(
              elevation: 12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(Icons.fingerprint, size: 40, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 12),
                          Text(
                            'PulseTime Attendance',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.brightness_6_rounded),
                            onPressed: () {
                              final ThemeMode newMode =
                                  _themeController.themeMode.value == ThemeMode.dark
                                      ? ThemeMode.light
                                      : ThemeMode.dark;
                              _themeController.updateTheme(newMode);
                              Get.changeThemeMode(newMode);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'एडमिन लॉगिन',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'ईमेल पता',
                          prefixIcon: Icon(Icons.mail_outline_rounded),
                        ),
                        validator: (String? value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'कृपया ईमेल दर्ज करें।';
                          }
                          if (!GetUtils.isEmail(value.trim())) {
                            return 'मान्य ईमेल पता आवश्यक है।';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'पासवर्ड',
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'पासवर्ड दर्ज करना आवश्यक है।';
                          }
                          if (value.length < 6) {
                            return 'कम से कम 6 अक्षरों का पासवर्ड डालें।';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      PrimaryButton(
                        text: 'लॉगिन करें',
                        onPressed: _handleLogin,
                        icon: Icons.arrow_forward_rounded,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'सुरक्षित लॉगिन के बाद आप कर्मचारियों की हाज़िरी को फेस और फिंगरप्रिंट से रिकॉर्ड कर सकते हैं।',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
