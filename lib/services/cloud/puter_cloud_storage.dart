import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:mindspace/core/errors/app_exception.dart';

/// Puter cloud storage service for persisting PDF files.
///
/// Uses Puter's REST endpoints directly:
/// - POST /fs/mkdir — create directories
/// - POST /fs/write — upload files (multipart FormData)
/// - POST /fs/read — download files
/// - POST /fs/readdir — list directory contents
/// - POST /fs/delete — delete files
/// - POST /fs/stat — get file info
///
/// All paths use ~/ prefix which resolves to /{username}/.
class PuterCloudStorage {
  PuterCloudStorage(this._dio);

  final Dio _dio;
  static const String _appFolder = '~/mindspace/documents';

  Options _authOptions(String token) => Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

  /// Ensure the app folder exists on Puter cloud storage.
  Future<void> ensureAppFolder(String token) async {
    try {
      await _dio.post(
        '/fs/mkdir',
        options: _authOptions(token),
        data: {'path': _appFolder, 'create_missing_parents': true},
      );
    } catch (e) {
      // Folder may already exist — that's fine
    }
  }

  /// Upload a PDF file to Puter cloud storage using multipart FormData.
  Future<String> uploadPdf({
    required String token,
    required String documentId,
    required Uint8List fileBytes,
    required String fileName,
  }) async {
    if (token.isEmpty) {
      throw const AiException('Not authenticated. Please sign in again.');
    }

    final cloudPath = '$_appFolder/$documentId.pdf';

    try {
      final formData = FormData.fromMap({
        'path': cloudPath,
        'file': MultipartFile.fromBytes(
          fileBytes,
          filename: '$documentId.pdf',
        ),
      });

      final response = await _dio.post(
        '/fs/write',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
          sendTimeout: const Duration(seconds: 120),
          receiveTimeout: const Duration(seconds: 30),
        ),
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return cloudPath;
      }

      throw AiException('Upload failed: ${response.statusMessage}');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const AiException('Authentication expired. Please sign in again.');
      }
      if (e.response?.statusCode == 413) {
        throw const AiException('File too large for cloud storage.');
      }
      throw AiException('Cloud upload failed: ${e.message ?? "Network error"}');
    }
  }

  /// Download a PDF file from Puter cloud storage.
  Future<Uint8List?> downloadPdf({
    required String token,
    required String documentId,
  }) async {
    if (token.isEmpty) return null;

    final cloudPath = '$_appFolder/$documentId.pdf';

    try {
      final response = await _dio.post(
        '/fs/read',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          responseType: ResponseType.bytes,
        ),
        data: {'path': cloudPath},
      );

      if (response.statusCode == 200 && response.data != null) {
        if (response.data is Uint8List) return response.data as Uint8List;
        if (response.data is List<int>) return Uint8List.fromList(response.data as List<int>);
      }
      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      return null;
    }
  }

  /// Generate a temporary read URL for a PDF.
  Future<String?> getReadUrl({
    required String token,
    required String documentId,
  }) async {
    if (token.isEmpty) return null;

    final cloudPath = '$_appFolder/$documentId.pdf';

    try {
      final response = await _dio.post(
        '/fs/sign',
        options: _authOptions(token),
        data: {'path': cloudPath},
      );

      if (response.statusCode == 200 && response.data is Map) {
        return response.data['url']?.toString();
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Delete a PDF from Puter cloud storage.
  Future<bool> deletePdf({
    required String token,
    required String documentId,
  }) async {
    if (token.isEmpty) return false;

    final cloudPath = '$_appFolder/$documentId.pdf';

    try {
      await _dio.post(
        '/fs/delete',
        options: _authOptions(token),
        data: {'path': cloudPath},
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  /// List all PDFs in the app folder.
  Future<List<CloudFileInfo>> listPdfs({required String token}) async {
    if (token.isEmpty) return [];

    try {
      final response = await _dio.post(
        '/fs/readdir',
        options: _authOptions(token),
        data: {'path': _appFolder},
      );

      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List)
            .whereType<Map>()
            .map((item) => CloudFileInfo(
                  name: item['name']?.toString() ?? '',
                  path: item['path']?.toString() ?? '',
                  size: (item['size'] as num?)?.toInt() ?? 0,
                ))
            .toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }
}

/// Metadata about a file in Puter cloud storage.
class CloudFileInfo {
  const CloudFileInfo({
    required this.name,
    required this.path,
    required this.size,
  });

  final String name;
  final String path;
  final int size;
}
