import 'employee_model.dart';

/// FaceCaptureResult कैमरा से कैप्चर किए चेहरे का टेम्पलेट और इमेज पथ लौटाता है।
class FaceCaptureResult {
  /// विश्लेषण के बाद प्राप्त फेस टेम्पलेट।
  final FaceTemplate template;

  /// यदि इमेज को लोकल में सेव किया गया है तो उसका पथ।
  final String? imagePath;

  FaceCaptureResult({
    required this.template,
    required this.imagePath,
  });
}
