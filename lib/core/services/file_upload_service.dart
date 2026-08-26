import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';
import 'package:mindspace/features/dashboard/domain/entities/document.dart';

class FileUploadService {
  static final Map<String, Uint8List> webBytesCache = {};

  static Future<FilePickerResult?> pickPdf() async {
    return await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: false,
      withData: kIsWeb,
    );
  }

  static Future<Document?> processUpload(FilePickerResult result) async {
    if (result.files.isEmpty) return null;
    final file = result.files.first;

    String destPath = '';
    int pages = 1;

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
    } catch (_) {}

    if (kIsWeb) {
      destPath = 'web://${file.name}';
      if (file.bytes != null) {
        webBytesCache[destPath] = file.bytes!;
      }
    } else {
      if (file.path == null) return null;
      final appDir = await getApplicationDocumentsDirectory();
      final documentsDir = Directory('${appDir.path}/documents');
      if (!await documentsDir.exists()) {
        await documentsDir.create(recursive: true);
      }

      final sourceFile = File(file.path!);
      destPath = '${documentsDir.path}/${file.name}';
      await sourceFile.copy(destPath);
    }

    return Document(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: file.name.replaceAll('.pdf', ''),
      fileName: file.name,
      filePath: destPath,
      pageCount: pages,
      fileSizeBytes: file.size,
      createdAt: DateTime.now(),
    );
  }

  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
