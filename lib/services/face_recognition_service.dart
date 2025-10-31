import 'dart:io';

import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../mvc/models/employee_model.dart';
import '../mvc/models/face_capture_result.dart';

/// FaceRecognitionService कैमरा इमेज का विश्लेषण करके फेस टेम्पलेट तैयार करती है।
class FaceRecognitionService extends GetxService {
  late final FaceDetector _detector;

  @override
  void onInit() {
    super.onInit();
    _detector = FaceDetector(
      options: FaceDetectorOptions(
        enableClassification: true,
        enableTracking: true,
        performanceMode: FaceDetectorMode.accurate,
      ),
    );
  }

  /// प्रदान किये गये फोटो से फेस टेम्पलेट निकालने वाली विधि।
  Future<FaceTemplate?> extractTemplateFromFile(XFile file) async {
    final InputImage inputImage = InputImage.fromFilePath(file.path);
    final List<Face> faces = await _detector.processImage(inputImage);
    if (faces.isEmpty) {
      return null;
    }
    final Face face = faces.first;
    final FaceTemplate template = FaceTemplate(
      leftEyeOpenProbability: face.leftEyeOpenProbability,
      rightEyeOpenProbability: face.rightEyeOpenProbability,
      smilingProbability: face.smilingProbability,
      boundingBoxWidth: face.boundingBox.width,
      boundingBoxHeight: face.boundingBox.height,
      headEulerAngleY: face.headEulerAngleY,
      headEulerAngleZ: face.headEulerAngleZ,
    );
    return template;
  }

  /// यदि आवश्यक हो तो इमेज को डिवाइस पर सेव करने वाली विधि।
  Future<String> _storeImage(XFile file, String identifier) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final Directory facesDir = Directory(p.join(directory.path, 'faces'));
    if (!facesDir.existsSync()) {
      facesDir.createSync(recursive: true);
    }
    final String filePath =
        p.join(facesDir.path, '${identifier}_${DateTime.now().millisecondsSinceEpoch}.jpg');
    await file.saveTo(filePath);
    return filePath;
  }

  /// इमेज का विश्लेषण कर टेम्पलेट व ऑप्शनल सेव पथ लौटाने वाली सुविधा।
  Future<FaceCaptureResult?> analyseAndMaybeStore(
    XFile file, {
    required bool persist,
    required String ownerId,
  }) async {
    final FaceTemplate? template = await extractTemplateFromFile(file);
    if (template == null) {
      return null;
    }
    String? storedPath;
    if (persist) {
      storedPath = await _storeImage(file, ownerId);
    }
    return FaceCaptureResult(template: template, imagePath: storedPath);
  }

  @override
  void onClose() {
    _detector.close();
    super.onClose();
  }
}
