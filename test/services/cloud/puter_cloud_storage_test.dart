import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindspace/core/errors/app_exception.dart';
import 'package:mindspace/services/cloud/puter_cloud_storage.dart';

void main() {
  late PuterCloudStorage storage;

  setUp(() {
    storage = PuterCloudStorage(Dio());
  });

  group('PuterCloudStorage', () {
    test('uploadPdf throws AiException when token is empty', () async {
      expect(
        () => storage.uploadPdf(
          token: '',
          documentId: 'doc1',
          fileBytes: Uint8List.fromList([1, 2, 3]),
          fileName: 'test.pdf',
        ),
        throwsA(isA<AiException>()),
      );
    });

    test('downloadPdf returns null when token is empty', () async {
      final result = await storage.downloadPdf(
        token: '',
        documentId: 'doc1',
      );
      expect(result, isNull);
    });

    test('deletePdf returns false when token is empty', () async {
      final result = await storage.deletePdf(
        token: '',
        documentId: 'doc1',
      );
      expect(result, isFalse);
    });

    test('listPdfs returns empty list when token is empty', () async {
      final result = await storage.listPdfs(token: '');
      expect(result, isEmpty);
    });

    test('getReadUrl returns null when token is empty', () async {
      final result = await storage.getReadUrl(
        token: '',
        documentId: 'doc1',
      );
      expect(result, isNull);
    });

    test('CloudFileInfo stores name, path, and size', () {
      const info = CloudFileInfo(
        name: 'test.pdf',
        path: '/mindspace/documents/test.pdf',
        size: 1024,
      );

      expect(info.name, 'test.pdf');
      expect(info.path, '/mindspace/documents/test.pdf');
      expect(info.size, 1024);
    });
  });
}
