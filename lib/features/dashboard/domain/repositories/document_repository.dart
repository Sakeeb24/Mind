import 'package:mindspace/features/dashboard/domain/entities/document.dart';

abstract class DocumentRepository {
  Future<List<Document>> getAllDocuments();
  Future<List<Document>> getDocumentsByFolder(String? folderId);
  Future<Document?> getDocumentById(String id);
  Future<Document> addDocument(Document document);
  Future<void> updateDocument(Document document);
  Future<void> deleteDocument(String id);
  Future<void> moveToFolder(String documentId, String? folderId);
}
