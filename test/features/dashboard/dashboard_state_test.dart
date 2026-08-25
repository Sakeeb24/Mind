import 'package:flutter_test/flutter_test.dart';
import 'package:mindspace/features/dashboard/domain/entities/document.dart';
import 'package:mindspace/features/dashboard/presentation/providers/dashboard_provider.dart';

void main() {
  final fixedDate = DateTime.utc(2024);

  group('DashboardState', () {
    test('filteredDocuments filters by search query', () {
      final state = DashboardState(
        documents: [
          Document(id: '1', title: 'Flutter Guide', fileName: 'flutter.pdf', filePath: '/f', createdAt: fixedDate),
          Document(id: '2', title: 'Dart Handbook', fileName: 'dart.pdf', filePath: '/d', createdAt: fixedDate),
        ],
        searchQuery: 'flutter',
      );
      expect(state.filteredDocuments.length, 1);
      expect(state.filteredDocuments.first.title, 'Flutter Guide');
    });

    test('filteredDocuments filters by folder', () {
      final state = DashboardState(
        documents: [
          Document(id: '1', title: 'A', fileName: 'a.pdf', filePath: '/a', folderId: 'folder1', createdAt: fixedDate),
          Document(id: '2', title: 'B', fileName: 'b.pdf', filePath: '/b', createdAt: fixedDate),
        ],
        selectedFolderId: 'folder1',
      );
      expect(state.filteredDocuments.length, 1);
      expect(state.filteredDocuments.first.id, '1');
    });

    test('filteredDocuments sorts by name', () {
      final state = DashboardState(
        documents: [
          Document(id: '1', title: 'Banana', fileName: 'b.pdf', filePath: '/b', createdAt: fixedDate),
          Document(id: '2', title: 'Apple', fileName: 'a.pdf', filePath: '/a', createdAt: fixedDate),
        ],
        sortOption: SortOption.name,
      );
      expect(state.filteredDocuments.first.title, 'Apple');
      expect(state.filteredDocuments.last.title, 'Banana');
    });

    test('copyWith clears folder when clearFolder is true', () {
      const state = DashboardState(selectedFolderId: 'f1');
      final cleared = state.copyWith(clearFolder: true);
      expect(cleared.selectedFolderId, isNull);
    });
  });
}
