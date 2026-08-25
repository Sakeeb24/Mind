import 'package:flutter_test/flutter_test.dart';
import 'package:mindspace/features/document_viewer/domain/entities/sticky_note.dart';

void main() {
  final fixedDate = DateTime.utc(2024);

  group('StickyNote', () {
    test('copyWith preserves unchanged fields', () {
      final n = StickyNote(
        id: '1', documentId: 'doc1', pageNumber: 1,
        xPosition: 0.5, yPosition: 0.3, content: 'Note', createdAt: fixedDate,
      );
      final updated = n.copyWith(content: 'Updated');
      expect(updated.content, 'Updated');
      expect(updated.xPosition, 0.5);
      expect(updated.documentId, 'doc1');
      expect(updated.updatedAt, isNotNull);
    });

    test('equality is based on id', () {
      final n1 = StickyNote(id: '1', documentId: 'd', pageNumber: 1, xPosition: 0, yPosition: 0, content: 'a', createdAt: fixedDate);
      final n2 = StickyNote(id: '1', documentId: 'x', pageNumber: 2, xPosition: 1, yPosition: 1, content: 'b', createdAt: fixedDate);
      final n3 = StickyNote(id: '2', documentId: 'd', pageNumber: 1, xPosition: 0, yPosition: 0, content: 'a', createdAt: fixedDate);
      expect(n1, equals(n2));
      expect(n1 == n3, isFalse);
    });
  });
}
