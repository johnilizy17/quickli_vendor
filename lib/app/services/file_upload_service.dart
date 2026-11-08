import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:get/get.dart';
import '../constants/color_constant.dart';

class FileUploadService {
  final ImagePicker _imagePicker = ImagePicker();

  /// Pick an image from gallery
  Future<File?> pickImageFromGallery({bool crop = false}) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image == null) return null;

      if (crop) {
        return await _cropImage(File(image.path));
      }

      return File(image.path);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }
  }

  /// Take a photo with camera
  Future<File?> takePhoto({bool crop = false}) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (image == null) return null;

      if (crop) {
        return await _cropImage(File(image.path));
      }

      return File(image.path);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to take photo: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }
  }

  /// Show bottom sheet to choose between camera and gallery
  Future<File?> pickImageWithOptions({bool crop = false}) async {
    final result = await Get.bottomSheet<String>(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: ColorConstant.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: ColorConstant.lightGrey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Select Image Source',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: ColorConstant.samantic,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.camera_alt, color: ColorConstant.brandColor),
              title: const Text('Camera'),
              onTap: () {
                Get.back(result: 'camera');
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: ColorConstant.brandColor),
              title: const Text('Gallery'),
              onTap: () {
                Get.back(result: 'gallery');
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      isDismissible: true,
      enableDrag: true,
    );

    if (result == null) return null;

    File? file;
    if (result == 'camera') {
      file = await takePhoto(crop: crop);
    } else if (result == 'gallery') {
      file = await pickImageFromGallery(crop: crop);
    }

    return file;
  }

  /// Crop image
  Future<File?> _cropImage(File imageFile) async {
    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        compressQuality: 85,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: ColorConstant.brandColor,
            toolbarWidgetColor: ColorConstant.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
            hideBottomControls: false,
          ),
          IOSUiSettings(
            title: 'Crop Image',
            minimumAspectRatio: 1.0,
          ),
        ],
      );

      if (croppedFile != null) {
        return File(croppedFile.path);
      }
      // If user cancels cropping, return original image
      return imageFile;
    } catch (e) {
      print('Crop error: ${e.toString()}');
      Get.snackbar(
        'Crop Skipped',
        'Using original image',
        snackPosition: SnackPosition.BOTTOM,
      );
      // Return original image if cropping fails
      return imageFile;
    }
  }

  /// Pick a document file (image only - PDF support requires native file picker)
  Future<File?> pickDocument() async {
    try {
      // Using image picker for images (jpg, jpeg, png)
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );

      if (image != null) {
        return File(image.path);
      }

      return null;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick document: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }
  }

  /// Pick multiple documents (images only)
  Future<List<File>?> pickMultipleDocuments() async {
    try {
      // Using image picker for multiple images
      final List<XFile> images = await _imagePicker.pickMultiImage(
        imageQuality: 100,
      );

      if (images.isNotEmpty) {
        return images.map((image) => File(image.path)).toList();
      }

      return null;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick documents: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }
  }

  /// Check file size (in MB)
  double getFileSizeInMB(File file) {
    final bytes = file.lengthSync();
    return bytes / (1024 * 1024);
  }

  /// Validate file size
  bool validateFileSize(File file, {double maxSizeMB = 10}) {
    final sizeMB = getFileSizeInMB(file);
    if (sizeMB > maxSizeMB) {
      Get.snackbar(
        'Error',
        'File size exceeds ${maxSizeMB}MB limit',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
    return true;
  }

  /// Get file extension
  String getFileExtension(File file) {
    return file.path.split('.').last.toLowerCase();
  }

  /// Check if file is an image
  bool isImageFile(File file) {
    final extension = getFileExtension(file);
    return ['jpg', 'jpeg', 'png', 'gif'].contains(extension);
  }

  /// Check if file is a PDF
  bool isPdfFile(File file) {
    final extension = getFileExtension(file);
    return extension == 'pdf';
  }
}
