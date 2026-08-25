import 'dart:convert';

import 'package:hive_ce/hive.dart';
import 'package:mindspace/features/dashboard/domain/entities/document.dart';
import 'package:mindspace/features/dashboard/domain/repositories/document_repository.dart';

class HiveDocumentRepository implements DocumentRepository {
  HiveDocumentRepository(this._box);

  final Box _box;

  @override
  Future<List<Document>> getAllDocuments() async {
    return _box.values.map((e) => _fromMap(Map<String, dynamic>.from(jsonDecode(e as String)))).toList();
  }

  @override
  Future<List<Document>> getDocumentsByFolder(String? folderId) async {
    final docs = await getAllDocuments();
    if (folderId == null) return docs.where((d) => d.folderId == null).toList();
    return docs.where((d) => d.folderId == folderId).toList();
  }

  @override
  Future<Document?> getDocumentById(String id) async {
    final data = _box.get(id);
    if (data == null) return null;
    return _fromMap(Map<String, dynamic>.from(jsonDecode(data as String)));
  }

  @override
  Future<Document> addDocument(Document document) async {
    await _box.put(document.id, jsonEncode(_toMap(document)));
    return document;
  }

  @override
  Future<void> updateDocument(Document document) async {
    await _box.put(document.id, jsonEncode(_toMap(document)));
  }

  @override
  Future<void> deleteDocument(String id) async {
    await _box.delete(id);
  }

  @override
  Future<void> moveToFolder(String documentId, String? folderId) async {
    final doc = await getDocumentById(documentId);
    if (doc == null) return;
    await updateDocument(doc.copyWith(folderId: folderId));
  }

  Map<String, dynamic> _toMap(Document doc) => {
        'id': doc.id,
        'title': doc.title,
        'fileName': doc.fileName,
        'filePath': doc.filePath,
        'fileSizeBytes': doc.fileSizeBytes,
        'pageCount': doc.pageCount,
        'thumbnailPath': doc.thumbnailPath,
        'folderId': doc.folderId,
        'hasExtractedText': doc.hasExtractedText,
        'createdAt': doc.createdAt.toIso8601String(),
        'lastOpenedAt': doc.lastOpenedAt?.toIso8601String(),
      };

  Document _fromMap(Map<String, dynamic> m) => Document(
        id: m['id'] as String,
        title: m['title'] as String,
        fileName: m['fileName'] as String,
        filePath: m['filePath'] as String,
        fileSizeBytes: m['fileSizeBytes'] as int? ?? 0,
        pageCount: m['pageCount'] as int? ?? 0,
        thumbnailPath: m['thumbnailPath'] as String?,
        folderId: m['folderId'] as String?,
        hasExtractedText: m['hasExtractedText'] as bool? ?? false,
        createdAt: DateTime.parse(m['createdAt'] as String),
        lastOpenedAt: m['lastOpenedAt'] != null ? DateTime.parse(m['lastOpenedAt'] as String) : null,
      );
}
