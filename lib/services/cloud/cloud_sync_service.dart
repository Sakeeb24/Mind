import 'dart:async';
import 'dart:typed_data';
import 'package:hive_ce/hive.dart';
import 'package:mindspace/config/constants.dart';
import 'package:mindspace/services/cloud/puter_cloud_storage.dart';
import 'package:mindspace/services/cloud/puter_kv_service.dart';

/// Cloud synchronization service that bridges local Hive storage with Puter cloud.
///
/// Strategy:
/// - Local changes are written to Hive immediately (offline-first).
/// - When online, changes are pushed to Puter cloud (KV + FS).
/// - On app start or reconnect, cloud data is pulled and merged with local data.
/// - Conflict resolution: last-write-wins based on `updatedAt` timestamps.
class CloudSyncService {
  CloudSyncService({
    required this._cloudStorage,
    required this._kvService,
  });

  final PuterCloudStorage _cloudStorage;
  final PuterKVService _kvService;

  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;

  final _syncController = StreamController<SyncEvent>.broadcast();
  Stream<SyncEvent> get syncEvents => _syncController.stream;

  // ──────────────────────────────────────────
  // Public API
  // ──────────────────────────────────────────

  /// Perform a full sync: pull cloud → merge → push local changes.
  Future<SyncResult> fullSync(String token) async {
    if (token.isEmpty || _isSyncing) return SyncResult.noop();

    _isSyncing = true;
    _syncController.add(SyncEvent.started);

    try {
      final result = SyncResult();
      await _pullCloudData(token, result);
      await _pushLocalData(token, result);
      _syncController.add(SyncEvent.completed(result));
      return result;
    } catch (e) {
      _syncController.add(SyncEvent.failed(e.toString()));
      return SyncResult.error(e.toString());
    } finally {
      _isSyncing = false;
    }
  }

  /// Push a single document's metadata and file to cloud.
  Future<bool> pushDocument({
    required String token,
    required String documentId,
    required Map<String, dynamic> metadata,
    Uint8List? fileBytes,
  }) async {
    if (token.isEmpty) return false;

    try {
      await _kvService.saveDocument(token, documentId, metadata);
      if (fileBytes != null && fileBytes.isNotEmpty) {
        await _cloudStorage.uploadPdf(
          token: token,
          documentId: documentId,
          fileBytes: fileBytes,
          fileName: metadata['title']?.toString() ?? '$documentId.pdf',
        );
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Pull a single document's metadata from cloud.
  Future<Map<String, dynamic>?> pullDocument({
    required String token,
    required String documentId,
  }) async {
    if (token.isEmpty) return null;
    try {
      return await _kvService.getDocument(token, documentId);
    } catch (_) {
      return null;
    }
  }

  /// Push annotations (highlights + notes) to cloud.
  Future<bool> pushAnnotations({
    required String token,
    required String documentId,
    required List highlights,
    required List notes,
  }) async {
    if (token.isEmpty) return false;
    try {
      await Future.wait([
        _kvService.saveHighlights(token, documentId, highlights),
        _kvService.saveNotes(token, documentId, notes),
      ]);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Pull annotations from cloud.
  Future<AnnotationData?> pullAnnotations({
    required String token,
    required String documentId,
  }) async {
    if (token.isEmpty) return null;
    try {
      final results = await Future.wait([
        _kvService.getHighlights(token, documentId),
        _kvService.getNotes(token, documentId),
      ]);
      return AnnotationData(
        highlights: results[0],
        notes: results[1],
      );
    } catch (_) {
      return null;
    }
  }

  /// Push chat history to cloud.
  Future<bool> pushChatHistory({
    required String token,
    required String documentId,
    required List messages,
  }) async {
    if (token.isEmpty) return false;
    return _kvService.saveChatHistory(token, documentId, messages);
  }

  /// Pull chat history from cloud.
  Future<List> pullChatHistory({
    required String token,
    required String documentId,
  }) async {
    if (token.isEmpty) return [];
    return _kvService.getChatHistory(token, documentId);
  }

  /// Push canvas cards to cloud.
  Future<bool> pushCanvasCards({
    required String token,
    required String docId,
    required List cards,
  }) async {
    if (token.isEmpty) return false;
    return _kvService.saveCanvasCards(token, docId, cards);
  }

  /// Push folders to cloud.
  Future<bool> pushFolder({
    required String token,
    required String folderId,
    required Map<String, dynamic> metadata,
  }) async {
    if (token.isEmpty) return false;
    return _kvService.saveFolder(token, folderId, metadata);
  }

  /// Pull all folder IDs from cloud.
  Future<List<String>> pullFolderIds(String token) async {
    if (token.isEmpty) return [];
    return _kvService.listFolderIds(token);
  }

  /// Pull a single folder from cloud.
  Future<Map<String, dynamic>?> pullFolder({
    required String token,
    required String folderId,
  }) async {
    if (token.isEmpty) return null;
    return _kvService.getFolder(token, folderId);
  }

  /// Delete a document from cloud.
  Future<bool> deleteCloudDocument({
    required String token,
    required String documentId,
  }) async {
    if (token.isEmpty) return false;
    try {
      await Future.wait([
        _kvService.deleteDocument(token, documentId),
        _cloudStorage.deletePdf(token: token, documentId: documentId),
        _kvService.del(token: token, key: 'mindspace/highlights/$documentId'),
        _kvService.del(token: token, key: 'mindspace/notes/$documentId'),
        _kvService.del(token: token, key: 'mindspace/chat/$documentId'),
        _kvService.del(token: token, key: 'mindspace/summaries/$documentId'),
        _kvService.del(token: token, key: 'mindspace/canvas/$documentId'),
      ]);
      return true;
    } catch (_) {
      return false;
    }
  }

  void dispose() {
    _syncController.close();
  }

  // ──────────────────────────────────────────
  // Private: Pull cloud → merge with local
  // ──────────────────────────────────────────

  Future<void> _pullCloudData(String token, SyncResult result) async {
    try {
      final cloudDocIds = await _kvService.listDocumentIds(token);

      for (final docId in cloudDocIds) {
        final cloudMeta = await _kvService.getDocument(token, docId);
        if (cloudMeta == null) continue;

        final box = Hive.box(AppConstants.documentsBox);
        final localData = box.get(docId);

        if (localData == null) {
          box.put(docId, cloudMeta);
          result.documentsPulled++;
        } else {
          final cloudUpdated = cloudMeta['updatedAt']?.toString() ?? '';
          final localUpdated = (localData is Map) ? (localData['updatedAt']?.toString() ?? '') : '';
          if (cloudUpdated.compareTo(localUpdated) > 0) {
            box.put(docId, cloudMeta);
            result.documentsUpdated++;
          }
        }

        final cloudHighlights = await _kvService.getHighlights(token, docId);
        if (cloudHighlights.isNotEmpty) {
          final highlightsBox = Hive.box(AppConstants.highlightsBox);
          final localHighlights = highlightsBox.get(docId);
          if (localHighlights == null || (localHighlights is List && localHighlights.isEmpty)) {
            highlightsBox.put(docId, cloudHighlights);
            result.annotationsPulled++;
          }
        }

        final cloudNotes = await _kvService.getNotes(token, docId);
        if (cloudNotes.isNotEmpty) {
          final notesBox = Hive.box(AppConstants.notesBox);
          final localNotes = notesBox.get(docId);
          if (localNotes == null || (localNotes is List && localNotes.isEmpty)) {
            notesBox.put(docId, cloudNotes);
            result.annotationsPulled++;
          }
        }
      }

      final cloudFolderIds = await _kvService.listFolderIds(token);
      for (final folderId in cloudFolderIds) {
        final cloudFolder = await _kvService.getFolder(token, folderId);
        if (cloudFolder == null) continue;

        final box = Hive.box(AppConstants.foldersBox);
        final localFolder = box.get(folderId);
        if (localFolder == null) {
          box.put(folderId, cloudFolder);
          result.foldersPulled++;
        }
      }
    } catch (_) {
      // Pull errors are non-fatal
    }
  }

  // ──────────────────────────────────────────
  // Private: Push local → cloud
  // ──────────────────────────────────────────

  Future<void> _pushLocalData(String token, SyncResult result) async {
    try {
      final box = Hive.box(AppConstants.documentsBox);
      for (final key in box.keys) {
        final data = box.get(key);
        if (data == null) continue;

        final docId = key.toString();
        final meta = _toMap(data);

        await _kvService.saveDocument(token, docId, meta);
        result.documentsPushed++;

        final highlightsBox = Hive.box(AppConstants.highlightsBox);
        final highlights = highlightsBox.get(docId);
        if (highlights is List && highlights.isNotEmpty) {
          await _kvService.saveHighlights(token, docId, highlights);
        }

        final notesBox = Hive.box(AppConstants.notesBox);
        final notes = notesBox.get(docId);
        if (notes is List && notes.isNotEmpty) {
          await _kvService.saveNotes(token, docId, notes);
        }
      }

      final foldersBox = Hive.box(AppConstants.foldersBox);
      for (final key in foldersBox.keys) {
        final data = foldersBox.get(key);
        if (data == null) continue;

        final folderId = key.toString();
        final meta = _toMap(data);
        await _kvService.saveFolder(token, folderId, meta);
        result.foldersPushed++;
      }

      final canvasBox = Hive.box(AppConstants.canvasCardsBox);
      for (final key in canvasBox.keys) {
        final data = canvasBox.get(key);
        if (data == null) continue;
        final docId = key.toString();
        final cards = data is List ? data : [data];
        await _kvService.saveCanvasCards(token, docId, cards);
      }

      final chatBox = Hive.box(AppConstants.chatHistoryBox);
      for (final key in chatBox.keys) {
        final data = chatBox.get(key);
        if (data == null) continue;
        final docId = key.toString();
        final messages = data is List ? data : [data];
        await _kvService.saveChatHistory(token, docId, messages);
      }
    } catch (_) {
      // Push errors are non-fatal
    }
  }

  /// Safely convert a Hive value to a [Map].
  static Map<String, dynamic> _toMap(dynamic data) {
    if (data is Map) {
      final result = <String, dynamic>{};
      data.forEach((k, v) => result[k.toString()] = v);
      return result;
    }
    return {};
  }
}

/// Result of a sync operation.
class SyncResult {
  SyncResult();
  SyncResult.noop() : isNoop = true;
  SyncResult.error(this.errorMessage) : hasError = true;

  bool isNoop = false;
  bool hasError = false;
  String? errorMessage;

  int documentsPulled = 0;
  int documentsUpdated = 0;
  int documentsPushed = 0;
  int annotationsPulled = 0;
  int foldersPulled = 0;
  int foldersPushed = 0;

  int get totalChanges =>
      documentsPulled + documentsUpdated + documentsPushed + annotationsPulled + foldersPulled + foldersPushed;
}

/// Annotation data pulled from cloud.
class AnnotationData {
  const AnnotationData({
    required this.highlights,
    required this.notes,
  });

  final List highlights;
  final List notes;
}

/// Sync event for stream listeners.
class SyncEvent {
  const SyncEvent._(this.type, {this.result, this.error});

  final String type;
  final SyncResult? result;
  final String? error;

  static const SyncEvent started = SyncEvent._('started');
  static SyncEvent completed(SyncResult r) => SyncEvent._('completed', result: r);
  static SyncEvent failed(String e) => SyncEvent._('failed', error: e);
}
