import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import '../constants/api_route.dart';
import 'api_service.dart';

class RegistrationApiService {
  final ApiService _apiService = ApiService.to;

  RegistrationApiService();

  /// Upload a file to server
  Future<String?> uploadFile(File file, {String? folder}) async {
    try {
      print('[API] Uploading file: ${file.path.split('/').last} to folder: ${folder ?? 'default'}');
      
      final formData = FormData.fromMap({
        'files': await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
        if (folder != null) 'folder': folder,
      });

      final response = await _apiService.post(ApiRoute.uploadImage, data: formData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // The API returns { status, message, data: { urls: [...] } }
        final urls = response.data['data']?['urls'] as List?;
        if (urls != null && urls.isNotEmpty) {
          final url = urls[0] as String;
          print('[API] ✅ File uploaded successfully: $url');
          return url;
        }
        print('[API] ❌ No URLs in response: ${response.data}');
        return null;
      }

      print('[API] ❌ Upload failed with status: ${response.statusCode}');
      return null;
    } catch (e) {
      print('[API] ❌ Upload error: $e');
      _handleError(e);
      return null;
    }
  }

  /// Upload multiple files
  Future<List<String>?> uploadMultipleFiles(List<File> files,
      {String? folder}) async {
    try {
      print('[API] Uploading ${files.length} files to folder: ${folder ?? 'default'}');
      
      // Create form data with multiple files
      final formData = FormData();
      
      for (var file in files) {
        formData.files.add(MapEntry(
          'files',
          await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          ),
        ));
      }
      
      if (folder != null) {
        formData.fields.add(MapEntry('folder', folder));
      }

      final response = await _apiService.post(ApiRoute.uploadImage, data: formData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // The API returns { status, message, data: { urls: [...] } }
        final urls = response.data['data']?['urls'] as List?;
        if (urls != null && urls.isNotEmpty) {
          final urlStrings = urls.cast<String>();
          print('[API] ✅ Successfully uploaded ${urlStrings.length}/${files.length} files');
          return urlStrings;
        }
        print('[API] ❌ No URLs in response: ${response.data}');
        return [];
      }

      print('[API] ❌ Upload failed with status: ${response.statusCode}');
      return [];
    } catch (e) {
      print('[API] ❌ Multiple upload error: $e');
      _handleError(e);
      return null;
    }
  }

  /// Setup business information (onboarding step 1)
  Future<Map<String, dynamic>?> setupBusinessInfo(
      Map<String, dynamic> data) async {
    try {
      final response = await _apiService.post(ApiRoute.setupBusinessInfo, data: data);
      return response.data;
    } catch (e) {
      _handleError(e);
      return null;
    }
  }

  /// Setup KYC details (onboarding step 2)
  Future<Map<String, dynamic>?> setupKycDetails(
      Map<String, dynamic> data) async {
    try {
      final response = await _apiService.post(ApiRoute.setupKycDetails, data: data);
      return response.data;
    } catch (e) {
      _handleError(e);
      return null;
    }
  }

  /// Save business documents (alternative endpoint)
  Future<Map<String, dynamic>?> saveBusinessDocuments(
      Map<String, dynamic> data) async {
    try {
      print('[API] Saving business documents to /vendors/business-documents');
      print('[API] Data: $data');
      
      final response = await _apiService.post(ApiRoute.businessDocuments, data: data);
      
      print('[API] ✅ Business documents saved [${response.statusCode}]: ${response.data}');
      
      return response.data;
    } catch (e) {
      print('[API] ❌ Business documents save error: $e');
      _handleError(e);
      return null;
    }
  }

  /// Update business with documents field directly
  Future<Map<String, dynamic>?> updateBusinessDocuments(
      String businessId, Map<String, dynamic> documentsData) async {
    try {
      print('[API] Updating business $businessId with documents via PATCH');
      print('[API] Documents data: $documentsData');
      
      final payload = {
        'businessId': businessId,
        'documents': documentsData,
      };
      
      final response = await _apiService.patch('/business/$businessId', data: payload);
      
      print('[API] ✅ Business documents updated [${response.statusCode}]: ${response.data}');
      
      return response.data;
    } catch (e) {
      print('[API] ❌ Business update error: $e');
      _handleError(e);
      return null;
    }
  }

  /// Update verification step progress
  Future<Map<String, dynamic>?> updateVerificationStep(
      Map<String, dynamic> data) async {
    try {
      print('[API] Updating verification step with data: $data');
      
      final response = await _apiService.patch(ApiRoute.updateVerificationStep, data: data);
      
      print('[API] ✅ Verification step updated [${response.statusCode}]: ${response.data}');
      
      return response.data;
    } catch (e) {
      print('[API] ❌ Verification step update error: $e');
      _handleError(e);
      return null;
    }
  }

  /// Setup bank details (onboarding step 3)
  Future<Map<String, dynamic>?> setupBankDetails(
      Map<String, dynamic> data) async {
    try {
      final response = await _apiService.post(ApiRoute.setupBankDetails, data: data);
      return response.data;
    } catch (e) {
      _handleError(e);
      return null;
    }
  }

  /// Get vendor business profile with comprehensive review data
  Future<Map<String, dynamic>?> getVendorBusinessForReview() async {
    try {
      print('[API] Fetching vendor business with review=true...');
      final response = await _apiService.get(
        ApiRoute.getVendorBusiness,
        queryParameters: {'review': 'true'},
      );
      print('[API] ✅ Review data received');
      return response.data;
    } catch (e) {
      print('[API] ⚠️ Review endpoint failed, falling back to standard endpoint: $e');
      // Fallback to standard endpoint if review parameter not supported
      return getVendorBusiness();
    }
  }

  /// Get vendor business profile
  Future<Map<String, dynamic>?> getVendorBusiness() async {
    try {
      final response = await _apiService.get(ApiRoute.getVendorBusiness);
      return response.data;
    } catch (e) {
      _handleError(e);
      return null;
    }
  }

  /// Get address by latitude and longitude
  Future<Map<String, dynamic>?> getAddressByLatLng({
    required double lat,
    required double lng,
  }) async {
    try {
      print('[API] Getting address for coordinates: $lat, $lng');
      
      final response = await _apiService.get(
        ApiRoute.getAddressByLatLng,
        queryParameters: {
          'lat': lat,
          'lng': lng,
        },
      );

      if (response.statusCode == 200) {
        print('[API] ✅ Address retrieved successfully');
        return response.data;
      }

      print('[API] ❌ Address retrieval failed with status: ${response.statusCode}');
      return null;
    } catch (e) {
      print('[API] ❌ Address retrieval error: $e');
      // Don't show error snackbar for address lookup failures - fail silently
      return null;
    }
  }

  /// Update business details
  Future<Map<String, dynamic>?> updateBusinessDetails(
      String businessId, Map<String, dynamic> data) async {
    try {
      // Add businessId to the payload
      final payload = {
        'businessId': businessId,
        ...data,
      };
      
      print('[API] Updating business $businessId with data: $payload');
      
      final response = await _apiService.post('/business/update', data: payload);
      
      print('[API] ✅ Business update response [${response.statusCode}]: ${response.data}');
      
      return response.data;
    } catch (e) {
      print('[API] ❌ Business update error: $e');
      _handleError(e);
      return null;
    }
  }

  /// Handle errors
  void _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          Get.snackbar(
            'Connection Error',
            'Request timeout. Please check your internet connection.',
            snackPosition: SnackPosition.BOTTOM,
          );
          break;
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final message = error.response?.data['message'] ?? 'An error occurred';
          Get.snackbar(
            'Error ($statusCode)',
            message,
            snackPosition: SnackPosition.BOTTOM,
          );
          break;
        case DioExceptionType.cancel:
          Get.snackbar(
            'Cancelled',
            'Request was cancelled',
            snackPosition: SnackPosition.BOTTOM,
          );
          break;
        default:
          Get.snackbar(
            'Network Error',
            'Please check your internet connection',
            snackPosition: SnackPosition.BOTTOM,
          );
      }
    } else {
      Get.snackbar(
        'Error',
        error.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
