import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;

class RegistrationApiService {
  final Dio _dio;

  RegistrationApiService({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              baseUrl: 'https://api.quickli.com', // TODO: Replace with actual API URL
              connectTimeout: const Duration(seconds: 30),
              receiveTimeout: const Duration(seconds: 30),
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
            ));

  /// Upload a file to server
  Future<String?> uploadFile(File file, {String? folder}) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
        if (folder != null) 'folder': folder,
      });

      final response = await _dio.post('/api/upload', data: formData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data['url'] as String?;
      }

      return null;
    } catch (e) {
      _handleError(e);
      return null;
    }
  }

  /// Upload multiple files
  Future<List<String>?> uploadMultipleFiles(List<File> files,
      {String? folder}) async {
    try {
      final uploadTasks = files.map((file) => uploadFile(file, folder: folder));
      final results = await Future.wait(uploadTasks);
      return results.where((url) => url != null).cast<String>().toList();
    } catch (e) {
      _handleError(e);
      return null;
    }
  }

  /// Save business information
  Future<Map<String, dynamic>?> saveBusinessInfo(
      Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/api/vendor/business-info', data: data);
      return response.data;
    } catch (e) {
      _handleError(e);
      return null;
    }
  }

  /// Save owner verification
  Future<Map<String, dynamic>?> saveOwnerVerification(
      Map<String, dynamic> data) async {
    try {
      final response =
          await _dio.post('/api/vendor/owner-verification', data: data);
      return response.data;
    } catch (e) {
      _handleError(e);
      return null;
    }
  }

  /// Save business documents
  Future<Map<String, dynamic>?> saveBusinessDocuments(
      Map<String, dynamic> data) async {
    try {
      final response =
          await _dio.post('/api/vendor/business-documents', data: data);
      return response.data;
    } catch (e) {
      _handleError(e);
      return null;
    }
  }

  /// Save bank account
  Future<Map<String, dynamic>?> saveBankAccount(
      Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/api/vendor/bank-account', data: data);
      return response.data;
    } catch (e) {
      _handleError(e);
      return null;
    }
  }

  /// Save tax information
  Future<Map<String, dynamic>?> saveTaxInfo(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/api/vendor/tax-info', data: data);
      return response.data;
    } catch (e) {
      _handleError(e);
      return null;
    }
  }

  /// Submit complete registration
  Future<Map<String, dynamic>?> submitRegistration() async {
    try {
      final response = await _dio.post('/api/vendor/submit-registration');
      return response.data;
    } catch (e) {
      _handleError(e);
      return null;
    }
  }

  /// Get registration status
  Future<Map<String, dynamic>?> getRegistrationStatus() async {
    try {
      final response = await _dio.get('/api/vendor/registration-status');
      return response.data;
    } catch (e) {
      _handleError(e);
      return null;
    }
  }

  /// Verify bank account (using Paystack)
  Future<Map<String, dynamic>?> verifyBankAccount({
    required String accountNumber,
    required String bankCode,
  }) async {
    try {
      final response = await _dio.post(
        '/api/vendor/verify-bank-account',
        data: {
          'accountNumber': accountNumber,
          'bankCode': bankCode,
        },
      );
      return response.data;
    } catch (e) {
      _handleError(e);
      return null;
    }
  }

  /// Get list of supported banks
  Future<List<Map<String, dynamic>>?> getBanks() async {
    try {
      final response = await _dio.get('/api/vendor/banks');
      if (response.data is List) {
        return List<Map<String, dynamic>>.from(response.data);
      }
      return null;
    } catch (e) {
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
