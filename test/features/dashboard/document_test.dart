import 'package:flutter_test/flutter_test.dart';
import 'package:mindspace/features/dashboard/domain/entities/document.dart';

void main() {
  group('Document', () {
    test('toJson serializes all fields', () {
      final doc = Document(
        id: 'doc-1',
        title: 'Test Document',
        fileName: 'test.pdf',
        filePath: '/path/to/test.pdf',
        fileSizeBytes: 1024,
        pageCount: 10,
        folderId: 'folder-1',
        hasExtractedText: true,
        createdAt: DateTime(2026, 1, 1),
        lastOpenedAt: DateTime(2026, 1, 2),
      );

      final json = doc.toJson();

      expect(json['id'], 'doc-1');
      expect(json['title'], 'Test Document');
      expect(json['fileName'], 'test.pdf');
      expect(json['filePath'], '/path/to/test.pdf');
      expect(json['fileSizeBytes'], 1024);
      expect(json['pageCount'], 10);
      expect(json['folderId'], 'folder-1');
      expect(json['hasExtractedText'], true);
      expect(json['createdAt'], isNotNull);
      expect(json['lastOpenedAt'], isNotNull);
      expect(json['updatedAt'], isNotNull); // Auto-generated
    });

    test('fromJson deserializes correctly', () {
      final json = {
        'id': 'doc-1',
        'title': 'Test Document',
        'fileName': 'test.pdf',
        'filePath': '/path/to/test.pdf',
        'fileSizeBytes': 1024,
        'pageCount': 10,
        'folderId': 'folder-1',
        'hasExtractedText': true,
        'createdAt': '2026-01-01T00:00:00.000',
        'lastOpenedAt': '2026-01-02T00:00:00.000',
      };

      final doc = Document.fromJson(json);

      expect(doc.id, 'doc-1');
      expect(doc.title, 'Test Document');
      expect(doc.fileName, 'test.pdf');
      expect(doc.filePath, '/path/to/test.pdf');
      expect(doc.fileSizeBytes, 1024);
      expect(doc.pageCount, 10);
      expect(doc.folderId, 'folder-1');
      expect(doc.hasExtractedText, isTrue);
      expect(doc.createdAt, DateTime(2026, 1, 1));
      expect(doc.lastOpenedAt, DateTime(2026, 1, 2));
    });

    test('fromJson handles missing/null fields gracefully', () {
      final json = <String, dynamic>{
        'id': 'doc-1',
        'title': 'Test',
        'fileName': 'test.pdf',
        'filePath': '/path',
      };

      final doc = Document.fromJson(json);

      expect(doc.fileSizeBytes, 0);
      expect(doc.pageCount, 0);
      expect(doc.hasExtractedText, false);
      expect(doc.folderId, isNull);
      expect(doc.lastOpenedAt, isNull);
    });

    test('roundtrip toJson → fromJson preserves data', () {
      final original = Document(
        id: 'doc-1',
        title: 'Test',
        fileName: 'test.pdf',
        filePath: '/path',
        fileSizeBytes: 2048,
        pageCount: 5,
        createdAt: DateTime(2026, 6, 15),
      );

      final restored = Document.fromJson(original.toJson());

      expect(restored.id, original.id);
      expect(restored.title, original.title);
      expect(restored.fileName, original.fileName);
      expect(restored.fileSizeBytes, original.fileSizeBytes);
      expect(restored.pageCount, original.pageCount);
    });

    test('copyWith creates modified copy', () {
      final doc = Document(
        id: 'doc-1',
        title: 'Original',
        fileName: 'test.pdf',
        filePath: '/path',
        createdAt: DateTime(2026, 1, 1),
      );

      final updated = doc.copyWith(title: 'Updated', pageCount: 10);

      expect(updated.title, 'Updated');
      expect(updated.pageCount, 10);
      expect(updated.id, 'doc-1'); // unchanged
    });

    test('equality is based on id only', () {
      final doc1 = Document(
        id: 'doc-1',
        title: 'Title 1',
        fileName: 'a.pdf',
        filePath: '/a',
        createdAt: DateTime(2026, 1, 1),
      );

      final doc2 = Document(
        id: 'doc-1',
        title: 'Title 2',
        fileName: 'b.pdf',
        filePath: '/b',
        createdAt: DateTime(2026, 2, 2),
      );

      expect(doc1, equals(doc2));
    });
  });
}
