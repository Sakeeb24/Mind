import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindspace/config/theme.dart';
import 'package:mindspace/features/dashboard/domain/entities/document.dart';
import 'package:mindspace/features/dashboard/domain/repositories/document_repository.dart';
import 'package:mindspace/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:mindspace/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:mindspace/features/folders/domain/entities/folder.dart';
import 'package:mindspace/features/folders/domain/repositories/folder_repository.dart';
import 'package:mindspace/features/folders/presentation/providers/folder_provider.dart';

class FakeDocumentRepository implements DocumentRepository {
  final List<Document> _docs = [];
  @override
  Future<List<Document>> getAllDocuments() async => _docs;
  @override
  Future<List<Document>> getDocumentsByFolder(String? folderId) async =>
      _docs.where((d) => d.folderId == folderId).toList();
  @override
  Future<Document?> getDocumentById(String id) async {
    try { return _docs.firstWhere((d) => d.id == id); } catch (_) { return null; }
  }
  @override
  Future<Document> addDocument(Document document) async { _docs.add(document); return document; }
  @override
  Future<void> updateDocument(Document document) async {}
  @override
  Future<void> deleteDocument(String id) async { _docs.removeWhere((d) => d.id == id); }
  @override
  Future<void> moveToFolder(String documentId, String? folderId) async {}
}

class FakeFolderRepository implements FolderRepository {
  final List<Folder> _folders = [];
  @override
  Future<List<Folder>> getAllFolders() async => _folders;
  @override
  Future<Folder?> getFolderById(String id) async {
    try { return _folders.firstWhere((f) => f.id == id); } catch (_) { return null; }
  }
  @override
  Future<Folder> addFolder(Folder folder) async { _folders.add(folder); return folder; }
  @override
  Future<void> updateFolder(Folder folder) async {}
  @override
  Future<void> deleteFolder(String id) async { _folders.removeWhere((f) => f.id == id); }
}

Widget buildTestApp({DocumentRepository? docRepo, FolderRepository? folderRepo}) {
  return ProviderScope(
    overrides: [
      if (docRepo != null) documentRepositoryProvider.overrideWithValue(docRepo),
      if (folderRepo != null) folderRepositoryProvider.overrideWithValue(folderRepo),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      home: const DashboardScreen(),
    ),
  );
}

void main() {
  group('DashboardScreen', () {
    testWidgets('shows empty state when no documents', (tester) async {
      await tester.pumpWidget(buildTestApp(
        docRepo: FakeDocumentRepository(),
        folderRepo: FakeFolderRepository(),
      ));
      await tester.pumpAndSettle();
      expect(find.text('No documents yet'), findsOneWidget);
      expect(find.text('Upload your first PDF to get started'), findsOneWidget);
    });

    testWidgets('shows search bar', (tester) async {
      await tester.pumpWidget(buildTestApp(
        docRepo: FakeDocumentRepository(),
        folderRepo: FakeFolderRepository(),
      ));
      await tester.pumpAndSettle();
      expect(find.text('Search documents'), findsOneWidget);
    });

    testWidgets('shows MindSpace title in app bar', (tester) async {
      await tester.pumpWidget(buildTestApp(
        docRepo: FakeDocumentRepository(),
        folderRepo: FakeFolderRepository(),
      ));
      await tester.pumpAndSettle();
      expect(find.text('MindSpace'), findsOneWidget);
    });

    testWidgets('shows grid/list toggle button', (tester) async {
      await tester.pumpWidget(buildTestApp(
        docRepo: FakeDocumentRepository(),
        folderRepo: FakeFolderRepository(),
      ));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.view_list), findsOneWidget);
    });

    testWidgets('shows sort button', (tester) async {
      await tester.pumpWidget(buildTestApp(
        docRepo: FakeDocumentRepository(),
        folderRepo: FakeFolderRepository(),
      ));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.sort), findsOneWidget);
    });

    testWidgets('shows FAB for upload and folder creation', (tester) async {
      await tester.pumpWidget(buildTestApp(
        docRepo: FakeDocumentRepository(),
        folderRepo: FakeFolderRepository(),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(FloatingActionButton), findsNWidgets(2));
    });
  });
}
