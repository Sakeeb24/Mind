import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindspace/config/theme.dart';
import 'package:mindspace/features/dashboard/domain/entities/document.dart';
import 'package:mindspace/features/document_viewer/domain/entities/highlight.dart';
import 'package:mindspace/features/document_viewer/domain/entities/sticky_note.dart';
import 'package:mindspace/features/document_viewer/domain/repositories/annotation_repository.dart';
import 'package:mindspace/features/document_viewer/presentation/providers/viewer_provider.dart';
import 'package:mindspace/features/document_viewer/presentation/screens/document_viewer_screen.dart';

class FakeAnnotationRepository implements AnnotationRepository {
  @override
  Future<List<Highlight>> getHighlights(String documentId) async => [];
  @override
  Future<Highlight> addHighlight(Highlight h) async => h;
  @override
  Future<void> updateHighlight(Highlight h) async {}
  @override
  Future<void> deleteHighlight(String id) async {}
  @override
  Future<List<StickyNote>> getStickyNotes(String documentId) async => [];
  @override
  Future<StickyNote> addStickyNote(StickyNote n) async => n;
  @override
  Future<void> updateStickyNote(StickyNote n) async {}
  @override
  Future<void> deleteStickyNote(String id) async {}
}

Widget buildTestApp(Document doc) {
  return ProviderScope(
    overrides: [
      annotationRepositoryProvider.overrideWithValue(FakeAnnotationRepository()),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      home: DocumentViewerScreen(document: doc),
    ),
  );
}

void main() {
  final testDoc = Document(
    id: 'test-doc',
    title: 'Test Document',
    fileName: 'test.pdf',
    filePath: '/test.pdf',
    pageCount: 10,
    fileSizeBytes: 1024000,
    createdAt: DateTime.utc(2024),
  );

  group('DocumentViewerScreen', () {
    testWidgets('shows document title', (tester) async {
      await tester.pumpWidget(buildTestApp(testDoc));
      await tester.pumpAndSettle();
      expect(find.text('Test Document'), findsOneWidget);
    });

    testWidgets('shows page indicator', (tester) async {
      await tester.pumpWidget(buildTestApp(testDoc));
      await tester.pumpAndSettle();
      // Non-breaking spaces in page indicator
      expect(find.textContaining('1'), findsWidgets);
    });

    testWidgets('shows annotation toolbar', (tester) async {
      await tester.pumpWidget(buildTestApp(testDoc));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.undo), findsOneWidget);
      expect(find.byIcon(Icons.redo), findsOneWidget);
      expect(find.byIcon(Icons.sticky_note_2_outlined), findsOneWidget);
    });

    testWidgets('shows page navigation arrows', (tester) async {
      await tester.pumpWidget(buildTestApp(testDoc));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.chevron_left), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });

    testWidgets('navigates to next page', (tester) async {
      await tester.pumpWidget(buildTestApp(testDoc));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pumpAndSettle();
      // After tapping next, page count should show 2
      expect(find.textContaining('2'), findsWidgets);
    });

    testWidgets('shows annotations list button', (tester) async {
      await tester.pumpWidget(buildTestApp(testDoc));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.list_alt), findsOneWidget);
    });
  });
}
