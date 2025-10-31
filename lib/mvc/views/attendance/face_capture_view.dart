import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/face_capture_result.dart';
import '../../../services/face_recognition_service.dart';
import '../widgets/primary_button.dart';

/// FaceCaptureView कैमरा खोलकर उपयोगकर्ता का चेहरा कैप्चर करने की सुविधा देता है।
class FaceCaptureView extends StatefulWidget {
  const FaceCaptureView({
    super.key,
    required this.persistCapture,
    required this.ownerId,
  });

  /// क्या कैप्चर की गयी इमेज को फ़ाइल के रूप में सेव करना है?
  final bool persistCapture;

  /// पहचान हेतु उपयोग होने वाला ओनर आईडी।
  final String ownerId;

  @override
  State<FaceCaptureView> createState() => _FaceCaptureViewState();
}

class _FaceCaptureViewState extends State<FaceCaptureView> {
  CameraController? _cameraController;
  bool _isBusy = false;
  String? _errorMessage;

  FaceRecognitionService get _faceService => Get.find<FaceRecognitionService>();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  /// फ्रंट कैमरा इनिशियलाइज़ करने वाली विधि।
  Future<void> _initializeCamera() async {
    try {
      await _cameraController?.dispose();
      final List<CameraDescription> cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() {
          _errorMessage = 'डिवाइस कैमरा उपलब्ध नहीं है।';
        });
        return;
      }
      final CameraDescription selectedCamera = cameras.firstWhere(
        (CameraDescription camera) =>
            camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
      final CameraController controller = CameraController(
        selectedCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await controller.initialize();
      if (!mounted) return;
      setState(() {
        _cameraController = controller;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'कैमरा प्रारंभ करने में समस्या आयी: $e';
      });
    }
  }

  /// चेहरा कैप्चर करने वाली विधि।
  Future<void> _captureFace() async {
    final CameraController? controller = _cameraController;
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    setState(() {
      _isBusy = true;
    });
    try {
      final XFile image = await controller.takePicture();
      final FaceCaptureResult? result = await _faceService.analyseAndMaybeStore(
        image,
        persist: widget.persistCapture,
        ownerId: widget.ownerId,
      );
      if (result == null) {
        Get.snackbar(
          'चेहरा नहीं मिला',
          'कृपया प्रकाश पर्याप्त रखें और कैमरा के सामने सीधे देखें।',
        );
      } else {
        Get.back(result: result);
      }
    } catch (e) {
      Get.snackbar('त्रुटि', 'इमेज कैप्चर नहीं हो सकी: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isBusy = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('चेहरा कैप्चर करें'),
      ),
      body: _errorMessage != null
          ? Center(
              child: Text(
                _errorMessage!,
                textAlign: TextAlign.center,
              ),
            )
          : Column(
              children: <Widget>[
                Expanded(
                  child: _cameraController == null
                      ? const Center(child: CircularProgressIndicator())
                      : CameraPreview(_cameraController!),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        'निर्देश: फ्रंट कैमरा की ओर देखें, उचित रोशनी रखें और चेहरे को फ्रेम के बीच में रखें।',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      PrimaryButton(
                        text: 'चेहरा कैप्चर करें',
                        icon: Icons.camera_alt_rounded,
                        onPressed: _isBusy ? null : _captureFace,
                        isLoading: _isBusy,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
