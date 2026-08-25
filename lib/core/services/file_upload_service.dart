import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mindspace/features/dashboard/domain/entities/document.dart';

class FileUploadService {
  static Future<FilePickerResult?> pickPdf() async {
    return await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: false,
    );
  }

  static Future<Document?> processUpload(FilePickerResult result) async {
    if (result.files.isEmpty) return null;
    final file = result.files.first;
    if (file.path == null) return null;

    final appDir = await getApplicationDocumentsDirectory();
    final documentsDir = Directory('${appDir.path}/documents');
    if (!await documentsDir.exists()) {
      await documentsDir.create(recursive: true);
    }

    final sourceFile = File(file.path!);
    final destPath = '${documentsDir.path}/${file.name}';
    await sourceFile.copy(destPath);

    return Document(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: file.name.replaceAll('.pdf', ''),
      fileName: file.name,
      filePath: destPath,
      pageCount: 0,
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
