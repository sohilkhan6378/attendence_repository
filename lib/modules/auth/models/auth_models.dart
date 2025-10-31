/// ऑथेंटिकेशन क्रेडेंशियल्स को कैप्चर करने वाला मॉडल।
class AuthCredentials {
  AuthCredentials({required this.identifier, required this.otp});

  final String identifier;
  final String otp;
}

/// संगठन जानकारी मॉडल ताकि मल्टी टेनेंसी हैंडल की जा सके।
class OrganizationModel {
  OrganizationModel({required this.id, required this.name});

  final String id;
  final String name;
}
