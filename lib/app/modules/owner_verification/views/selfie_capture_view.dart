import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../constants/color_constant.dart';
import '../controllers/owner_verification_controller.dart';
import 'selfie_preview_view.dart';

class SelfCaptureView extends StatefulWidget {
  const SelfCaptureView({super.key});

  @override
  State<SelfCaptureView> createState() => _SelfCaptureViewState();
}

class _SelfCaptureViewState extends State<SelfCaptureView> with WidgetsBindingObserver {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  bool _isCapturing = false;
  String _instructionText = 'Initializing camera...';
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _cameraController;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      setState(() {
        _instructionText = 'Requesting camera permission...';
        _errorMessage = null;
      });

      // Request camera permission
      final permissionStatus = await Permission.camera.request();
      
      if (!permissionStatus.isGranted) {
        setState(() {
          _instructionText = 'Camera permission denied';
          _errorMessage = 'Please grant camera permission in settings';
        });
        return;
      }

      setState(() {
        _instructionText = 'Loading camera...';
      });

      // Get available cameras
      try {
        _cameras = await availableCameras();
      } catch (e) {
        print('[SelfCaptureView] Error getting cameras: $e');
        setState(() {
          _errorMessage = 'Failed to get camera list: ${e.toString()}';
          _instructionText = 'Camera error';
        });
        return;
      }

      if (_cameras == null || _cameras!.isEmpty) {
        setState(() {
          _instructionText = 'No camera available';
          _errorMessage = 'No cameras found on this device';
        });
        return;
      }

      // Get front camera
      CameraDescription? frontCamera;
      try {
        frontCamera = _cameras!.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
        );
      } catch (e) {
        // No front camera, use first available
        frontCamera = _cameras!.first;
        print('[SelfCaptureView] No front camera found, using first camera');
      }

      // Initialize camera controller
      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      try {
        await _cameraController!.initialize();
      } catch (e) {
        print('[SelfCaptureView] Camera initialize error: $e');
        setState(() {
          _errorMessage = 'Camera initialization failed: ${e.toString()}';
          _instructionText = 'Failed to start camera';
        });
        return;
      }

      if (!mounted) return;

      setState(() {
        _isCameraInitialized = true;
        _instructionText = 'Position your face within the oval';
        _errorMessage = null;
      });
    } catch (e) {
      print('[SelfCaptureView] General camera error: $e');
      if (mounted) {
        setState(() {
          _instructionText = 'Camera error';
          _errorMessage = e.toString();
        });
      }
    }
  }

  Future<void> _captureSelfie() async {
    if (_isCapturing ||
        _cameraController == null ||
        !_cameraController!.value.isInitialized) {
      return;
    }

    setState(() {
      _isCapturing = true;
      _instructionText = 'Capturing...';
    });

    try {
      // Capture image
      final image = await _cameraController!.takePicture();
      final imageFile = File(image.path);

      print('[SelfCaptureView] Selfie captured: ${image.path}');

      // Store in controller
      final controller = Get.find<OwnerVerificationController>();
      controller.selfieFile.value = imageFile;
      controller.selfiePath.value = image.path;

      // Navigate to preview
      Get.off(() => const SelfiePreviewView());
    } catch (e) {
      print('[SelfCaptureView] Capture error: $e');
      Get.snackbar(
        'Error',
        'Failed to capture selfie. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
      );
      
      if (mounted) {
        setState(() {
          _isCapturing = false;
          _instructionText = 'Position your face within the oval';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Camera Preview or Error
            if (_isCameraInitialized && _cameraController != null)
              Positioned.fill(
                child: CameraPreview(_cameraController!),
              )
            else
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_errorMessage == null)
                      CircularProgressIndicator(color: Colors.white)
                    else
                      Icon(Icons.error_outline, size: 64.sp, color: Colors.red),
                    SizedBox(height: 20.h),
                    Text(
                      _instructionText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    if (_errorMessage != null) ...[
                      SizedBox(height: 12.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32.w),
                        child: Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.red.shade300,
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      ElevatedButton.icon(
                        onPressed: _initializeCamera,
                        icon: Icon(Icons.refresh),
                        label: Text('Retry'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorConstant.brandColor,
                          padding: EdgeInsets.symmetric(
                            horizontal: 32.w,
                            vertical: 12.h,
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      TextButton(
                        onPressed: () => Get.back(),
                        child: Text(
                          'Go Back',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

            // Face oval overlay
            if (_isCameraInitialized)
              Positioned.fill(
                child: CustomPaint(
                  painter: FaceOvalPainter(),
                ),
              ),

            // Header
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 20.sp,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Owner information',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Your personal details as the business owner',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Instruction Text - Positioned below oval with 20px spacing
            if (_isCameraInitialized)
              Positioned(
                top: (MediaQuery.of(context).size.height * 0.32) + 
                     (MediaQuery.of(context).size.height * 0.36 / 2) + 20,
                left: 0,
                right: 0,
                child: Text(
                  _instructionText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.8),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
              ),

            // Bottom controls
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Capture Button
                  if (_isCameraInitialized)
                    Container(
                      padding: EdgeInsets.only(bottom: 20.h),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.6),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: GestureDetector(
                        onTap: !_isCapturing ? _captureSelfie : null,
                        child: Container(
                          width: 80.w,
                          height: 80.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 4,
                            ),
                          ),
                          child: Center(
                            child: _isCapturing
                                ? CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  )
                                : Container(
                                    width: 64.w,
                                    height: 64.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),

                  // Photo tips with pure white background
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24.r),
                        topRight: Radius.circular(24.r),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Photo tips:',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: ColorConstant.samantic,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        _PhotoTip(text: 'Good lighting — face a window or bright room'),
                        _PhotoTip(text: 'Look directly at the camera'),
                        _PhotoTip(text: 'No sunglasses, hat, or face covering'),
                        _PhotoTip(text: 'Center your face in the oval frame'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhotoTip extends StatelessWidget {
  final String text;

  const _PhotoTip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(
              fontSize: 13.sp,
              color: ColorConstant.deepGrey,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13.sp,
                color: ColorConstant.deepGrey,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for face oval guide
class FaceOvalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    // Center the oval in the upper portion of the screen
    final center = Offset(size.width / 2, size.height * 0.32);
    // Reduced oval size for better positioning
    final ovalWidth = size.width * 0.60;
    final ovalHeight = size.height * 0.36;

    canvas.drawOval(
      Rect.fromCenter(center: center, width: ovalWidth, height: ovalHeight),
      paint,
    );

    // Draw darkened areas outside the oval
    final backgroundPaint = Paint()..color = Colors.black.withOpacity(0.6);

    final path = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final ovalPath = Path()
      ..addOval(
        Rect.fromCenter(center: center, width: ovalWidth, height: ovalHeight),
      );

    canvas.drawPath(
      Path.combine(PathOperation.difference, path, ovalPath),
      backgroundPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
