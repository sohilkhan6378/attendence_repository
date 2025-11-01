import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

/// BiometricService डिवाइस के फिंगरप्रिंट या फेस आईडी को वैलिडेट करता है।
class BiometricService extends GetxService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  /// असली डिवाइस पर यह मेथड फिंगरप्रिंट/फेस वैरिफाई करेगा।
  Future<bool> authenticateFingerprint() async {
    try {
      final bool canCheck = await _localAuth.canCheckBiometrics;
      if (!canCheck) {
        return false;
      }
      return _localAuth.authenticate(
        localizedReason: 'फिंगरप्रिंट से उपस्थिति सुनिश्चित करें',
        options: const AuthenticationOptions(biometricOnly: true),
      );
    } catch (_) {
      return false;
    }
  }
}
