import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';
import 'package:mindspace/config/constants.dart';
import 'package:mindspace/core/errors/app_exception.dart';
import 'package:mindspace/features/dashboard/domain/entities/document.dart';
import 'package:mindspace/services/cloud/puter_cloud_storage.dart';
import 'package:mindspace/services/cloud/puter_kv_service.dart';
import 'package:dio/dio.dart';

/// Hive box name for persisting web-uploaded PDF bytes.
const String _webPdfsBox = 'web_pdf_bytes';

class FileUploadService {
  /// Pick a PDF file from the device.
  static Future<FilePickerResult?> pickPdf() async {
    return await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: false,
      withData: kIsWeb,
    );
  }

  /// Process an uploaded PDF: validate size, validate pages, persist bytes,
  /// and return a [Document] entity.
  ///
  /// Throws [ValidationException] for size/page limit violations,
  /// [PdfException] for corrupt or unreadable PDFs.
  static Future<Document> processUpload(FilePickerResult result) async {
    if (result.files.isEmpty) {
      throw const ValidationException('No file selected.');
    }
    final file = result.files.first;

    // ── 1. Enforce 50 MB file-size limit ──
    if (file.size > AppConstants.maxPdfSizeMb * 1024 * 1024) {
      throw ValidationException(
        'File is too large (${_formatSize(file.size)}). '
        'Maximum allowed size is ${AppConstants.maxPdfSizeMb} MB.',
      );
    }

    // ── 2. Open the PDF to validate and count pages ──
    int pages = 0;
    try {
      if (file.bytes != null) {
        final pdf = await PdfDocument.openData(file.bytes!);
        pages = pdf.pagesCount;
        await pdf.close();
      } else if (file.path != null) {
        final pdf = await PdfDocument.openFile(file.path!);
        pages = pdf.pagesCount;
        await pdf.close();
      }
    } on PdfException {
      throw const PdfException(
        'This file appears to be corrupt or is not a valid PDF. '
        'Please try a different file.',
      );
    } catch (e) {
      throw PdfException(
        'Unable to read this PDF file. It may be corrupt or password-protected. '
        'Error: $e',
      );
    }

    if (pages == 0) {
      throw const PdfException('This PDF has no pages. Please select a different file.');
    }

    // ── 3. Enforce 200-page limit ──
    if (pages > AppConstants.maxPagesPerDocument) {
      throw ValidationException(
        'This PDF has $pages pages. '
        'Maximum allowed is ${AppConstants.maxPagesPerDocument} pages.',
      );
    }

    // ── 4. Persist the file ──
    String destPath = '';

    if (kIsWeb) {
      // Persist web PDF bytes in a Hive box (survives page reloads via IndexedDB).
      destPath = 'web://${file.name}';
      if (file.bytes != null) {
        final box = Hive.box(_webPdfsBox);
        await box.put(destPath, file.bytes!);
      }
    } else {
      if (file.path == null) {
        throw const StorageException('Could not determine file path for upload.');
      }
      final appDir = await getApplicationDocumentsDirectory();
      final documentsDir = Directory('${appDir.path}/documents');
      if (!await documentsDir.exists()) {
        await documentsDir.create(recursive: true);
      }
      final sourceFile = File(file.path!);
      destPath = '${documentsDir.path}/${file.name}';
      await sourceFile.copy(destPath);
    }

    // ── 5. Generate title — remove only the final .pdf extension ──
    final title = file.name.replaceAll(RegExp(r'\.pdf$', caseSensitive: false), '');

    return Document(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      fileName: file.name,
      filePath: destPath,
      pageCount: pages,
      fileSizeBytes: file.size,
      createdAt: DateTime.now(),
    );
  }

  /// Load persisted web PDF bytes from Hive storage.
  static Uint8List? loadWebPdfBytes(String filePath) {
    if (!kIsWeb || !filePath.startsWith('web://')) return null;
    try {
      final box = Hive.box(_webPdfsBox);
      return box.get(filePath) as Uint8List?;
    } catch (_) {
      return null;
    }
  }

  /// Upload the document's PDF bytes to Puter cloud storage and persist metadata via KV.
  ///
  /// This is called after local persistence to ensure the document is available
  /// on other devices signed into the same Puter account.
  static Future<void> syncToCloud({
    required String token,
    required Document document,
    Uint8List? fileBytes,
  }) async {
    if (token.isEmpty) return;

    final dio = Dio(BaseOptions(
      baseUrl: 'https://api.puter.com',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 60),
    ));

    final cloudStorage = PuterCloudStorage(dio);
    final kvService = PuterKVService(dio);

    try {
      // Upload file if bytes are available
      if (fileBytes != null && fileBytes.isNotEmpty) {
        await cloudStorage.uploadPdf(
          token: token,
          documentId: document.id,
          fileBytes: fileBytes,
          fileName: document.fileName,
        );
      }

      // Persist metadata via KV
      await kvService.saveDocument(token, document.id, document.toJson());
    } catch (_) {
      // Cloud sync failure is non-fatal — data is safe locally
    }
  }

  /// Ensure the web PDF bytes Hive box is opened at app startup.
  static Future<void> ensureWebPdfsBox() async {
    if (kIsWeb && !Hive.isBoxOpen(_webPdfsBox)) {
      await Hive.openBox(_webPdfsBox);
    }
  }

  static String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  static String formatFileSize(int bytes) => _formatSize(bytes);
}
