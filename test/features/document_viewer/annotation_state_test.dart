import 'package:flutter_test/flutter_test.dart';
import 'package:mindspace/features/document_viewer/domain/entities/highlight.dart';
import 'package:mindspace/features/document_viewer/presentation/providers/viewer_provider.dart';

void main() {
  group('AnnotationState', () {
    test('initial state has empty lists', () {
      const state = AnnotationState();
      expect(state.highlights, isEmpty);
      expect(state.stickyNotes, isEmpty);
      expect(state.selectedColor, '#FFEB3B');
      expect(state.undoStack, isEmpty);
      expect(state.redoStack, isEmpty);
    });

    test('copyWith preserves unchanged fields', () {
      final fixedDate = DateTime.utc(2024);
      final h = Highlight(id: '1', documentId: 'd', pageNumber: 1, selectedText: 'a', color: '#FF0', startOffset: 0, endOffset: 1, createdAt: fixedDate);
      const state = AnnotationState();
      final updated = state.copyWith(highlights: [h], selectedColor: '#66BB6A');
      expect(updated.highlights.length, 1);
      expect(updated.selectedColor, '#66BB6A');
      expect(updated.stickyNotes, isEmpty);
    });

    test('highlightColors has 4 entries', () {
      expect(highlightColors.length, 4);
      expect(highlightColors, contains('#FFEB3B'));
      expect(highlightColors, contains('#EC407A'));
    });
  });
}
