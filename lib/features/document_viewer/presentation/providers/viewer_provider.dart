import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';
import 'package:mindspace/config/constants.dart';
import 'package:mindspace/features/document_viewer/data/repositories/hive_annotation_repository.dart';
import 'package:mindspace/features/document_viewer/domain/entities/highlight.dart';
import 'package:mindspace/features/document_viewer/domain/entities/sticky_note.dart';
import 'package:mindspace/features/document_viewer/domain/repositories/annotation_repository.dart';

/// Provider for the annotation repository.
final annotationRepositoryProvider = Provider<AnnotationRepository>((ref) {
  final highlightsBox = Hive.box(AppConstants.highlightsBox);
  final notesBox = Hive.box(AppConstants.notesBox);
  return HiveAnnotationRepository(highlightsBox, notesBox);
});

/// Highlight colors available for text selection.
const highlightColors = [
  '#FFEB3B', // Yellow
  '#66BB6A', // Green
  '#42A5F5', // Blue
  '#EC407A', // Pink
];

/// Annotation state holding highlights, notes, and undo/redo stacks.
class AnnotationState {
  const AnnotationState({
    this.highlights = const [],
    this.stickyNotes = const [],
    this.selectedColor = '#FFEB3B',
    this.undoStack = const [],
    this.redoStack = const [],
  });

  final List<Highlight> highlights;
  final List<StickyNote> stickyNotes;
  final String selectedColor;
  final List<Map<String, Object?>> undoStack;
  final List<Map<String, Object?>> redoStack;

  AnnotationState copyWith({
    List<Highlight>? highlights,
    List<StickyNote>? stickyNotes,
    String? selectedColor,
    List<Map<String, Object?>>? undoStack,
    List<Map<String, Object?>>? redoStack,
  }) {
    return AnnotationState(
      highlights: highlights ?? this.highlights,
      stickyNotes: stickyNotes ?? this.stickyNotes,
      selectedColor: selectedColor ?? this.selectedColor,
      undoStack: undoStack ?? this.undoStack,
      redoStack: redoStack ?? this.redoStack,
    );
  }
}

/// Annotation notifier managing highlights, notes, and undo/redo.
class AnnotationNotifier extends Notifier<AnnotationState> {

  @override
  AnnotationState build() => const AnnotationState();

  void loadAnnotations(String documentId) async {
    final repo = ref.read(annotationRepositoryProvider);
    final highlights = await repo.getHighlights(documentId);
    final notes = await repo.getStickyNotes(documentId);
    state = state.copyWith(highlights: highlights, stickyNotes: notes, undoStack: [], redoStack: []);
  }

  void setColor(String color) {
    state = state.copyWith(selectedColor: color);
  }

  Future<void> addHighlight(Highlight highlight) async {
    final repo = ref.read(annotationRepositoryProvider);
    await repo.addHighlight(highlight);
    state = state.copyWith(
      highlights: [...state.highlights, highlight],
      undoStack: [...state.undoStack, {'type': 'add_highlight', 'data': highlight}],
      redoStack: [],
    );
  }

  Future<void> deleteHighlight(String id) async {
    final repo = ref.read(annotationRepositoryProvider);
    final highlight = state.highlights.firstWhere((h) => h.id == id);
    await repo.deleteHighlight(id);
    state = state.copyWith(
      highlights: state.highlights.where((h) => h.id != id).toList(),
      undoStack: [...state.undoStack, {'type': 'delete_highlight', 'data': highlight}],
      redoStack: [],
    );
  }

  Future<void> addStickyNote(StickyNote note) async {
    final repo = ref.read(annotationRepositoryProvider);
    await repo.addStickyNote(note);
    state = state.copyWith(
      stickyNotes: [...state.stickyNotes, note],
      undoStack: [...state.undoStack, {'type': 'add_note', 'data': note}],
      redoStack: [],
    );
  }

  Future<void> updateStickyNote(StickyNote note) async {
    final repo = ref.read(annotationRepositoryProvider);
    await repo.updateStickyNote(note);
    final oldNote = state.stickyNotes.firstWhere((n) => n.id == note.id);
    state = state.copyWith(
      stickyNotes: state.stickyNotes.map((n) => n.id == note.id ? note : n).toList(),
      undoStack: [...state.undoStack, {'type': 'update_note', 'data': oldNote, 'new': note}],
      redoStack: [],
    );
  }

  Future<void> deleteStickyNote(String id) async {
    final repo = ref.read(annotationRepositoryProvider);
    final note = state.stickyNotes.firstWhere((n) => n.id == id);
    await repo.deleteStickyNote(id);
    state = state.copyWith(
      stickyNotes: state.stickyNotes.where((n) => n.id != id).toList(),
      undoStack: [...state.undoStack, {'type': 'delete_note', 'data': note}],
      redoStack: [],
    );
  }

  Future<void> undo() async {
    if (state.undoStack.isEmpty) return;
    final repo = ref.read(annotationRepositoryProvider);
    final last = state.undoStack.last;
    final newUndo = List<Map<String, Object?>>.from(state.undoStack)..removeLast();

    switch (last['type'] as String) {
      case 'add_highlight':
        final h = last['data'] as Highlight;
        await repo.deleteHighlight(h.id);
        state = state.copyWith(
          highlights: state.highlights.where((x) => x.id != h.id).toList(),
          undoStack: newUndo,
          redoStack: [...state.redoStack, last],
        );
      case 'delete_highlight':
        final h = last['data'] as Highlight;
        await repo.addHighlight(h);
        state = state.copyWith(
          highlights: [...state.highlights, h],
          undoStack: newUndo,
          redoStack: [...state.redoStack, last],
        );
      case 'add_note':
        final n = last['data'] as StickyNote;
        await repo.deleteStickyNote(n.id);
        state = state.copyWith(
          stickyNotes: state.stickyNotes.where((x) => x.id != n.id).toList(),
          undoStack: newUndo,
          redoStack: [...state.redoStack, last],
        );
      case 'delete_note':
        final n = last['data'] as StickyNote;
        await repo.addStickyNote(n);
        state = state.copyWith(
          stickyNotes: [...state.stickyNotes, n],
          undoStack: newUndo,
          redoStack: [...state.redoStack, last],
        );
      case 'update_note':
        final oldNote = last['data'] as StickyNote;
        await repo.updateStickyNote(oldNote);
        state = state.copyWith(
          stickyNotes: state.stickyNotes.map((n) => n.id == oldNote.id ? oldNote : n).toList(),
          undoStack: newUndo,
          redoStack: [...state.redoStack, last],
        );
    }
  }

  Future<void> redo() async {
    if (state.redoStack.isEmpty) return;
    final repo = ref.read(annotationRepositoryProvider);
    final last = state.redoStack.last;
    final newRedo = List<Map<String, Object?>>.from(state.redoStack)..removeLast();

    switch (last['type'] as String) {
      case 'add_highlight':
        final h = last['data'] as Highlight;
        await repo.addHighlight(h);
        state = state.copyWith(
          highlights: [...state.highlights, h],
          undoStack: [...state.undoStack, last],
          redoStack: newRedo,
        );
      case 'delete_highlight':
        final h = last['data'] as Highlight;
        await repo.deleteHighlight(h.id);
        state = state.copyWith(
          highlights: state.highlights.where((x) => x.id != h.id).toList(),
          undoStack: [...state.undoStack, last],
          redoStack: newRedo,
        );
      case 'add_note':
        final n = last['data'] as StickyNote;
        await repo.addStickyNote(n);
        state = state.copyWith(
          stickyNotes: [...state.stickyNotes, n],
          undoStack: [...state.undoStack, last],
          redoStack: newRedo,
        );
      case 'delete_note':
        final n = last['data'] as StickyNote;
        await repo.deleteStickyNote(n.id);
        state = state.copyWith(
          stickyNotes: state.stickyNotes.where((x) => x.id != n.id).toList(),
          undoStack: [...state.undoStack, last],
          redoStack: newRedo,
        );
      case 'update_note':
        final newNote = last['new'] as StickyNote;
        await repo.updateStickyNote(newNote);
            state = state.copyWith(
          stickyNotes: state.stickyNotes.map((n) => n.id == newNote.id ? newNote : n).toList(),
          undoStack: [...state.undoStack, last],
          redoStack: newRedo,
        );
    }
  }
}

final annotationProvider = NotifierProvider<AnnotationNotifier, AnnotationState>(
  AnnotationNotifier.new,
);
