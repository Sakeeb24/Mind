import 'package:flutter_test/flutter_test.dart';
import 'package:filesize/filesize.dart';
import 'package:mindspace/features/dashboard/domain/entities/document.dart';

void main() {
  final fixedDate = DateTime.utc(2024);

  group('Document', () {
    test('fileSizeFormatted delegates to filesize package', () {
      final doc = Document(
        id: '1', title: 'Test', fileName: 'test.pdf', filePath: '/test.pdf',
        fileSizeBytes: 1536, createdAt: fixedDate,
      );
      expect(doc.fileSizeFormatted, filesize(1536));
    });

    test('fileSizeFormatted formats zero bytes', () {
      final doc = Document(
        id: '1', title: 'Test', fileName: 'test.pdf', filePath: '/test.pdf',
        fileSizeBytes: 0, createdAt: fixedDate,
      );
      expect(doc.fileSizeFormatted, filesize(0));
    });

    test('fileSizeFormatted formats large file', () {
      final doc = Document(
        id: '1', title: 'Test', fileName: 'test.pdf', filePath: '/test.pdf',
        fileSizeBytes: 2621440, createdAt: fixedDate,
      );
      expect(doc.fileSizeFormatted, filesize(2621440));
    });

    test('copyWith preserves unchanged fields', () {
      final doc = Document(
        id: '1', title: 'Original', fileName: 'test.pdf', filePath: '/test.pdf',
        fileSizeBytes: 1024, pageCount: 10, createdAt: fixedDate,
      );
      final updated = doc.copyWith(title: 'New Title');
      expect(updated.title, 'New Title');
      expect(updated.fileName, 'test.pdf');
      expect(updated.fileSizeBytes, 1024);
      expect(updated.pageCount, 10);
    });

    test('equality is based on id', () {
      final doc1 = Document(id: '1', title: 'A', fileName: 'a.pdf', filePath: '/a', createdAt: fixedDate);
      final doc2 = Document(id: '1', title: 'B', fileName: 'b.pdf', filePath: '/b', createdAt: DateTime.utc(2025));
      final doc3 = Document(id: '2', title: 'A', fileName: 'a.pdf', filePath: '/a', createdAt: fixedDate);
      expect(doc1, equals(doc2));
      expect(doc1 == doc3, isFalse);
    });
  });
}
