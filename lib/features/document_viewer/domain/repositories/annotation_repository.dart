import 'package:mindspace/features/document_viewer/domain/entities/highlight.dart';
import 'package:mindspace/features/document_viewer/domain/entities/sticky_note.dart';

abstract class AnnotationRepository {
  // Highlights
  Future<List<Highlight>> getHighlights(String documentId);
  Future<Highlight> addHighlight(Highlight highlight);
  Future<void> updateHighlight(Highlight highlight);
  Future<void> deleteHighlight(String id);

  // Sticky Notes
  Future<List<StickyNote>> getStickyNotes(String documentId);
  Future<StickyNote> addStickyNote(StickyNote note);
  Future<void> updateStickyNote(StickyNote note);
  Future<void> deleteStickyNote(String id);
}
