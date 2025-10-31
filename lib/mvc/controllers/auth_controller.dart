import 'package:get/get.dart';

/// AuthController एडमिन लॉगिन की स्थिति को मैनेज करता है।
class AuthController extends GetxController {
  /// वर्तमान उपयोगकर्ता का डिस्प्ले नाम।
  final RxString currentUserName = 'PulseTime Admin'.obs;

  /// क्या उपयोगकर्ता लॉगइन है?
  final RxBool isLoggedIn = false.obs;

  static const String _adminEmail = 'admin@pulsetime.app';
  static const String _adminPassword = 'Pulse@123';

  /// एडमिन क्रेडेंशियल की जाँच करने वाली विधि।
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    if (email.trim().toLowerCase() == _adminEmail && password == _adminPassword) {
      isLoggedIn.value = true;
      currentUserName.value = 'PulseTime Admin';
      return true;
    }
    return false;
  }

  /// लॉगआउट करके ऐप की स्थिति रीसेट करता है।
  void logout() {
    isLoggedIn.value = false;
  }
}
