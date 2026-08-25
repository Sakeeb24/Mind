import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';
import 'package:mindspace/config/constants.dart';
import 'package:mindspace/features/dashboard/data/repositories/hive_document_repository.dart';
import 'package:mindspace/features/dashboard/domain/entities/document.dart';
import 'package:mindspace/features/dashboard/domain/repositories/document_repository.dart';

/// Provider for the document repository.
final documentRepositoryProvider = Provider<DocumentRepository>((ref) {
  final box = Hive.box(AppConstants.documentsBox);
  return HiveDocumentRepository(box);
});

/// Sort option for documents.
enum SortOption { recent, name, dateAdded, size }

/// Dashboard state.
class DashboardState {
  const DashboardState({
    this.documents = const [],
    this.isLoading = false,
    this.selectedFolderId,
    this.sortOption = SortOption.recent,
    this.searchQuery = '',
  });

  final List<Document> documents;
  final bool isLoading;
  final String? selectedFolderId;
  final SortOption sortOption;
  final String searchQuery;

  List<Document> get filteredDocuments {
    var docs = List<Document>.from(documents);

    // Filter by folder
    if (selectedFolderId != null) {
      docs = docs.where((d) => d.folderId == selectedFolderId).toList();
    } else {
      docs = docs.where((d) => d.folderId == null).toList();
    }

    // Filter by search
    if (searchQuery.isNotEmpty) {
      docs = docs.where((d) => d.title.toLowerCase().contains(searchQuery.toLowerCase())).toList();
    }

    // Sort
    switch (sortOption) {
      case SortOption.recent:
        docs.sort((a, b) => (b.lastOpenedAt ?? b.createdAt).compareTo(a.lastOpenedAt ?? a.createdAt));
      case SortOption.name:
        docs.sort((a, b) => a.title.compareTo(b.title));
      case SortOption.dateAdded:
        docs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      case SortOption.size:
        docs.sort((a, b) => b.fileSizeBytes.compareTo(a.fileSizeBytes));
    }

    return docs;
  }

  DashboardState copyWith({
    List<Document>? documents,
    bool? isLoading,
    String? selectedFolderId,
    SortOption? sortOption,
    String? searchQuery,
    bool clearFolder = false,
  }) {
    return DashboardState(
      documents: documents ?? this.documents,
      isLoading: isLoading ?? this.isLoading,
      selectedFolderId: clearFolder ? null : (selectedFolderId ?? this.selectedFolderId),
      sortOption: sortOption ?? this.sortOption,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

/// Dashboard notifier.
class DashboardNotifier extends Notifier<DashboardState> {
  @override
  DashboardState build() {
    _loadDocuments();
    return const DashboardState();
  }

  Future<void> _loadDocuments() async {
    state = state.copyWith(isLoading: true);
    final repo = ref.read(documentRepositoryProvider);
    final docs = await repo.getAllDocuments();
    state = state.copyWith(documents: docs, isLoading: false);
  }

  Future<void> addDocument(Document document) async {
    final repo = ref.read(documentRepositoryProvider);
    await repo.addDocument(document);
    await _loadDocuments();
  }

  Future<void> deleteDocument(String id) async {
    final repo = ref.read(documentRepositoryProvider);
    await repo.deleteDocument(id);
    await _loadDocuments();
  }

  Future<void> moveToFolder(String documentId, String? folderId) async {
    final repo = ref.read(documentRepositoryProvider);
    await repo.moveToFolder(documentId, folderId);
    await _loadDocuments();
  }

  void setFolder(String? folderId) {
    state = state.copyWith(selectedFolderId: folderId, clearFolder: folderId == null);
  }

  void setSort(SortOption option) {
    state = state.copyWith(sortOption: option);
  }

  void setSearch(String query) {
    state = state.copyWith(searchQuery: query);
  }
}

final dashboardProvider = NotifierProvider<DashboardNotifier, DashboardState>(
  DashboardNotifier.new,
);
