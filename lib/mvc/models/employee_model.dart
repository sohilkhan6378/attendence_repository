import 'dart:math';

import 'package:uuid/uuid.dart';

/// FaceTemplate मॉडल चेहरे की पहचान हेतु निकाले गये आँकड़ों को सुरक्षित करता है।
class FaceTemplate {
  /// बायीं आँख खुली रहने की संभावना।
  final double? leftEyeOpenProbability;

  /// दायीं आँख खुली रहने की संभावना।
  final double? rightEyeOpenProbability;

  /// मुस्कुराने की संभावना।
  final double? smilingProbability;

  /// चेहरे का बॉक्स चौड़ाई।
  final double boundingBoxWidth;

  /// चेहरे का बॉक्स ऊँचाई।
  final double boundingBoxHeight;

  /// सिर के Y अक्ष पर झुकाव का कोण।
  final double? headEulerAngleY;

  /// सिर के Z अक्ष पर झुकाव का कोण।
  final double? headEulerAngleZ;

  const FaceTemplate({
    required this.leftEyeOpenProbability,
    required this.rightEyeOpenProbability,
    required this.smilingProbability,
    required this.boundingBoxWidth,
    required this.boundingBoxHeight,
    required this.headEulerAngleY,
    required this.headEulerAngleZ,
  });

  /// फेस टेम्पलेट को मैप में बदलने वाली विधि।
  Map<String, dynamic> toJson() => <String, dynamic>{
        'leftEyeOpenProbability': leftEyeOpenProbability,
        'rightEyeOpenProbability': rightEyeOpenProbability,
        'smilingProbability': smilingProbability,
        'boundingBoxWidth': boundingBoxWidth,
        'boundingBoxHeight': boundingBoxHeight,
        'headEulerAngleY': headEulerAngleY,
        'headEulerAngleZ': headEulerAngleZ,
      };

  /// मैप को फेस टेम्पलेट में बदलने वाली फ़ैक्टरी।
  factory FaceTemplate.fromJson(Map<String, dynamic> json) => FaceTemplate(
        leftEyeOpenProbability: (json['leftEyeOpenProbability'] as num?)?.toDouble(),
        rightEyeOpenProbability:
            (json['rightEyeOpenProbability'] as num?)?.toDouble(),
        smilingProbability: (json['smilingProbability'] as num?)?.toDouble(),
        boundingBoxWidth: (json['boundingBoxWidth'] as num).toDouble(),
        boundingBoxHeight: (json['boundingBoxHeight'] as num).toDouble(),
        headEulerAngleY: (json['headEulerAngleY'] as num?)?.toDouble(),
        headEulerAngleZ: (json['headEulerAngleZ'] as num?)?.toDouble(),
      );

  /// दो फेस टेम्पलेट के बीच अंतर का औसत निकालने वाली विधि, जितना कम परिणाम उतना अधिक मेल।
  double difference(FaceTemplate other) {
    final List<double> deltas = <double>[];

    void appendIfValid(double? a, double? b) {
      if (a != null && b != null) {
        deltas.add((a - b).abs());
      }
    }

    appendIfValid(leftEyeOpenProbability, other.leftEyeOpenProbability);
    appendIfValid(rightEyeOpenProbability, other.rightEyeOpenProbability);
    appendIfValid(smilingProbability, other.smilingProbability);
    appendIfValid(headEulerAngleY, other.headEulerAngleY);
    appendIfValid(headEulerAngleZ, other.headEulerAngleZ);

    final double widthDelta =
        (boundingBoxWidth - other.boundingBoxWidth).abs() /
            max(boundingBoxWidth, other.boundingBoxWidth);
    final double heightDelta =
        (boundingBoxHeight - other.boundingBoxHeight).abs() /
            max(boundingBoxHeight, other.boundingBoxHeight);
    deltas.add(widthDelta);
    deltas.add(heightDelta);

    if (deltas.isEmpty) {
      return 1.0;
    }
    return deltas.reduce((double a, double b) => a + b) / deltas.length;
  }
}

/// EmployeeModel प्रत्येक कर्मचारी का बुनियादी डेटा व बायोमेट्रिक सिग्नेचर सुरक्षित करता है।
class EmployeeModel {
  /// कर्मचारी का यूनिक आईडी।
  final String id;

  /// कर्मचारी का नाम।
  final String name;

  /// कर्मचारी का विभाग।
  final String department;

  /// कर्मचारी का पद/डिज़िग्नेशन।
  final String designation;

  /// कर्मचारी का व्यक्तिगत कोड।
  final String employeeCode;

  /// चेहरा पहचानने हेतु सेव किया गया फेस टेम्पलेट।
  final FaceTemplate? faceTemplate;

  /// क्या कर्मचारी का फिंगरप्रिंट दर्ज हो चुका है?
  final bool fingerprintRegistered;

  /// चेहरा रजिस्टर करते समय सेव की गयी इमेज का पथ।
  final String? faceImagePath;

  /// कर्मचारी के क्रिएट होने की तिथि।
  final DateTime createdAt;

  EmployeeModel({
    required this.id,
    required this.name,
    required this.department,
    required this.designation,
    required this.employeeCode,
    required this.faceTemplate,
    required this.fingerprintRegistered,
    required this.faceImagePath,
    required this.createdAt,
  });

  /// कर्मचारियों को लिस्ट में जोड़ते समय उपयोगी हेल्पर।
  factory EmployeeModel.create({
    required String name,
    required String department,
    required String designation,
    required bool fingerprintRegistered,
    FaceTemplate? faceTemplate,
    String? faceImagePath,
  }) {
    final String id = const Uuid().v4();
    final String code = 'EMP${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    return EmployeeModel(
      id: id,
      name: name,
      department: department,
      designation: designation,
      employeeCode: code,
      faceTemplate: faceTemplate,
      fingerprintRegistered: fingerprintRegistered,
      faceImagePath: faceImagePath,
      createdAt: DateTime.now(),
    );
  }

  /// मॉडल को JSON मैप में बदलने वाली विधि।
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'department': department,
        'designation': designation,
        'employeeCode': employeeCode,
        'faceTemplate': faceTemplate?.toJson(),
        'fingerprintRegistered': fingerprintRegistered,
        'faceImagePath': faceImagePath,
        'createdAt': createdAt.toIso8601String(),
      };

  /// JSON मैप को मॉडल में परिवर्तित करने वाली फ़ैक्टरी।
  factory EmployeeModel.fromJson(Map<String, dynamic> json) => EmployeeModel(
        id: json['id'] as String,
        name: json['name'] as String,
        department: json['department'] as String,
        designation: json['designation'] as String,
        employeeCode: json['employeeCode'] as String,
        faceTemplate: json['faceTemplate'] == null
            ? null
            : FaceTemplate.fromJson(
                json['faceTemplate'] as Map<String, dynamic>,
              ),
        fingerprintRegistered: json['fingerprintRegistered'] as bool? ?? false,
        faceImagePath: json['faceImagePath'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  /// मौजूदा मॉडल से नई कॉपी बनाने की सुविधा।
  EmployeeModel copyWith({
    String? name,
    String? department,
    String? designation,
    FaceTemplate? faceTemplate,
    bool? fingerprintRegistered,
    String? faceImagePath,
  }) {
    return EmployeeModel(
      id: id,
      name: name ?? this.name,
      department: department ?? this.department,
      designation: designation ?? this.designation,
      employeeCode: employeeCode,
      faceTemplate: faceTemplate ?? this.faceTemplate,
      fingerprintRegistered:
          fingerprintRegistered ?? this.fingerprintRegistered,
      faceImagePath: faceImagePath ?? this.faceImagePath,
      createdAt: createdAt,
    );
  }
}
