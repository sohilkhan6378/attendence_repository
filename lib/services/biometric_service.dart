import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

/// BiometricService फिंगरप्रिंट एवं अन्य बायोमेट्रिक प्रमाणीकरण संभालती है।
class BiometricService extends GetxService {
  final LocalAuthentication _auth = LocalAuthentication();

  /// डिवाइस पर बायोमेट्रिक की उपलब्धता जांचने वाली विधि।
  Future<bool> canAuthenticate() async {
    final bool isDeviceSupported = await _auth.isDeviceSupported();
    final bool canCheck = await _auth.canCheckBiometrics;
    return isDeviceSupported && canCheck;
  }

  /// बायोमेट्रिक प्रमाणीकरण चलाने वाली विधि।
  Future<bool> authenticate({
    required String reason,
  }) async {
    final bool hasSupport = await canAuthenticate();
    if (!hasSupport) {
      return false;
    }
    try {
      final bool didAuthenticate = await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
          useErrorDialogs: true,
        ),
      );
      return didAuthenticate;
    } on Exception {
      return false;
    }
  }
}
