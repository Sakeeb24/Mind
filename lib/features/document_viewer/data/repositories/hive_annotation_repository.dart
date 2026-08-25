import 'dart:convert';
import 'package:hive_ce/hive.dart';
import 'package:mindspace/features/document_viewer/domain/entities/highlight.dart';
import 'package:mindspace/features/document_viewer/domain/entities/sticky_note.dart';
import 'package:mindspace/features/document_viewer/domain/repositories/annotation_repository.dart';

class HiveAnnotationRepository implements AnnotationRepository {
  HiveAnnotationRepository(this._highlightsBox, this._notesBox);
  final Box _highlightsBox;
  final Box _notesBox;

  @override
  Future<List<Highlight>> getHighlights(String documentId) async {
    final all = _highlightsBox.values
        .map((e) => _highlightFromMap(Map<String, dynamic>.from(jsonDecode(e as String))))
        .where((h) => h.documentId == documentId)
        .toList();
    return all;
  }

  @override
  Future<Highlight> addHighlight(Highlight highlight) async {
    await _highlightsBox.put(highlight.id, jsonEncode(_highlightToMap(highlight)));
    return highlight;
  }

  @override
  Future<void> updateHighlight(Highlight highlight) async {
    await _highlightsBox.put(highlight.id, jsonEncode(_highlightToMap(highlight)));
  }

  @override
  Future<void> deleteHighlight(String id) async {
    await _highlightsBox.delete(id);
  }

  @override
  Future<List<StickyNote>> getStickyNotes(String documentId) async {
    final all = _notesBox.values
        .map((e) => _noteFromMap(Map<String, dynamic>.from(jsonDecode(e as String))))
        .where((n) => n.documentId == documentId)
        .toList();
    return all;
  }

  @override
  Future<StickyNote> addStickyNote(StickyNote note) async {
    await _notesBox.put(note.id, jsonEncode(_noteToMap(note)));
    return note;
  }

  @override
  Future<void> updateStickyNote(StickyNote note) async {
    await _notesBox.put(note.id, jsonEncode(_noteToMap(note)));
  }

  @override
  Future<void> deleteStickyNote(String id) async {
    await _notesBox.delete(id);
  }

  Map<String, dynamic> _highlightToMap(Highlight h) => {
        'id': h.id,
        'documentId': h.documentId,
        'pageNumber': h.pageNumber,
        'selectedText': h.selectedText,
        'color': h.color,
        'startOffset': h.startOffset,
        'endOffset': h.endOffset,
        'createdAt': h.createdAt.toIso8601String(),
      };

  Highlight _highlightFromMap(Map<String, dynamic> m) => Highlight(
        id: m['id'] as String,
        documentId: m['documentId'] as String,
        pageNumber: m['pageNumber'] as int,
        selectedText: m['selectedText'] as String,
        color: m['color'] as String,
        startOffset: m['startOffset'] as int,
        endOffset: m['endOffset'] as int,
        createdAt: DateTime.parse(m['createdAt'] as String),
      );

  Map<String, dynamic> _noteToMap(StickyNote n) => {
        'id': n.id,
        'documentId': n.documentId,
        'pageNumber': n.pageNumber,
        'xPosition': n.xPosition,
        'yPosition': n.yPosition,
        'content': n.content,
        'createdAt': n.createdAt.toIso8601String(),
        'updatedAt': n.updatedAt?.toIso8601String(),
      };

  StickyNote _noteFromMap(Map<String, dynamic> m) => StickyNote(
        id: m['id'] as String,
        documentId: m['documentId'] as String,
        pageNumber: m['pageNumber'] as int,
        xPosition: (m['xPosition'] as num).toDouble(),
        yPosition: (m['yPosition'] as num).toDouble(),
        content: m['content'] as String,
        createdAt: DateTime.parse(m['createdAt'] as String),
        updatedAt: m['updatedAt'] != null ? DateTime.parse(m['updatedAt'] as String) : null,
      );
}
