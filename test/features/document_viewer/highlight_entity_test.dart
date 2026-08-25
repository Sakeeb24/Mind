import 'package:flutter_test/flutter_test.dart';
import 'package:mindspace/features/document_viewer/domain/entities/highlight.dart';

void main() {
  final fixedDate = DateTime.utc(2024);

  group('Highlight', () {
    test('copyWith preserves unchanged fields', () {
      final h = Highlight(
        id: '1', documentId: 'doc1', pageNumber: 1, selectedText: 'hello',
        color: '#FFEB3B', startOffset: 0, endOffset: 5, createdAt: fixedDate,
      );
      final updated = h.copyWith(color: '#66BB6A');
      expect(updated.color, '#66BB6A');
      expect(updated.selectedText, 'hello');
      expect(updated.documentId, 'doc1');
    });

    test('equality is based on id', () {
      final h1 = Highlight(id: '1', documentId: 'd', pageNumber: 1, selectedText: 'a', color: '#FF0', startOffset: 0, endOffset: 1, createdAt: fixedDate);
      final h2 = Highlight(id: '1', documentId: 'x', pageNumber: 2, selectedText: 'b', color: '#00F', startOffset: 0, endOffset: 1, createdAt: fixedDate);
      final h3 = Highlight(id: '2', documentId: 'd', pageNumber: 1, selectedText: 'a', color: '#FF0', startOffset: 0, endOffset: 1, createdAt: fixedDate);
      expect(h1, equals(h2));
      expect(h1 == h3, isFalse);
    });
  });
}
