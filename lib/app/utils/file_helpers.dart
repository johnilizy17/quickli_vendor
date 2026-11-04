import 'dart:io';

class FileHelpers {
  /// Format file size to human-readable format
  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
    }
  }

  /// Get file size from File object
  static String getFileSizeString(File file) {
    final bytes = file.lengthSync();
    return formatFileSize(bytes);
  }

  /// Get file extension
  static String getFileExtension(String path) {
    return path.split('.').last.toLowerCase();
  }

  /// Get file name without extension
  static String getFileNameWithoutExtension(String path) {
    final fileName = path.split('/').last;
    return fileName.split('.').first;
  }

  /// Get file name from path
  static String getFileName(String path) {
    return path.split('/').last;
  }

  /// Check if file is an image
  static bool isImage(String path) {
    final extension = getFileExtension(path);
    return ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].contains(extension);
  }

  /// Check if file is a PDF
  static bool isPDF(String path) {
    final extension = getFileExtension(path);
    return extension == 'pdf';
  }

  /// Check if file is a document
  static bool isDocument(String path) {
    final extension = getFileExtension(path);
    return ['pdf', 'doc', 'docx', 'txt', 'xls', 'xlsx'].contains(extension);
  }

  /// Get MIME type from file extension
  static String getMimeType(String path) {
    final extension = getFileExtension(path);
    
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'pdf':
        return 'application/pdf';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case 'xls':
        return 'application/vnd.ms-excel';
      case 'xlsx':
        return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
      case 'txt':
        return 'text/plain';
      default:
        return 'application/octet-stream';
    }
  }

  /// Validate file size
  static bool validateSize(File file, {double maxSizeMB = 10}) {
    final bytes = file.lengthSync();
    final sizeMB = bytes / (1024 * 1024);
    return sizeMB <= maxSizeMB;
  }

  /// Validate file type
  static bool validateType(String path, List<String> allowedExtensions) {
    final extension = getFileExtension(path);
    return allowedExtensions.contains(extension);
  }
}
