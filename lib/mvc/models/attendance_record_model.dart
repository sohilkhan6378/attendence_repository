/// AttendanceStatus यह दर्शाता है कि कर्मचारी समय पर उपस्थित है या नहीं।
enum AttendanceStatus {
  /// उपस्थिति दर्ज की गयी।
  present,

  /// अनुपस्थिति/प्रवेश विफल।
  absent,
}

/// AttendanceMethod हाज़िरी दर्ज करने के उपयोग किये गये माध्यम को दर्शाता है।
enum AttendanceMethod {
  /// चेहरा पहचान के माध्यम से।
  face,

  /// उँगली/बायोमेट्रिक के माध्यम से।
  fingerprint,

  /// मैनुअल प्रविष्टि।
  manual,
}

/// AttendanceRecordModel किसी एक हाज़िरी प्रविष्टि का पूर्ण विवरण रखता है।
class AttendanceRecordModel {
  /// रिकॉर्ड का यूनिक आईडी।
  final String id;

  /// किस कर्मचारी की हाज़िरी दर्ज की गयी।
  final String employeeId;

  /// किस नाम से प्रविष्टि हुई।
  final String employeeName;

  /// दर्ज करने का समय।
  final DateTime timestamp;

  /// प्रयुक्त माध्यम।
  final AttendanceMethod method;

  /// स्टेटस।
  final AttendanceStatus status;

  /// यदि कोई टिप्पणी हो।
  final String note;

  AttendanceRecordModel({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.timestamp,
    required this.method,
    required this.status,
    required this.note,
  });

  /// मॉडल को JSON में बदलने वाली विधि।
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'employeeId': employeeId,
        'employeeName': employeeName,
        'timestamp': timestamp.toIso8601String(),
        'method': method.name,
        'status': status.name,
        'note': note,
      };

  /// JSON मैप से मॉडल तैयार करने वाली फ़ैक्टरी।
  factory AttendanceRecordModel.fromJson(Map<String, dynamic> json) {
    return AttendanceRecordModel(
      id: json['id'] as String,
      employeeId: json['employeeId'] as String,
      employeeName: json['employeeName'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      method: AttendanceMethod.values
          .firstWhere((AttendanceMethod value) => value.name == json['method']),
      status: AttendanceStatus.values
          .firstWhere((AttendanceStatus value) => value.name == json['status']),
      note: json['note'] as String? ?? '',
    );
  }
}
