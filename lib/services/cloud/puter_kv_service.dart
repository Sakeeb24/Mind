import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:mindspace/core/errors/app_exception.dart';

/// Puter Key-Value store service for persisting app metadata.
///
/// Uses Puter's /drivers/call endpoint with the "puter-kvstore" interface.
/// Verified working: POST https://api.puter.com/drivers/call
/// with { "interface": "puter-kvstore", "method": "...", "args": {...} }
class PuterKVService {
  PuterKVService(this._dio);

  final Dio _dio;
  static const String _prefix = 'mindspace';

  /// Make a call to the Puter /drivers/call endpoint.
  Future<dynamic> _driverCall({
    required String token,
    required String method,
    Map<String, dynamic>? args,
  }) async {
    if (token.isEmpty) return null;

    try {
      final response = await _dio.post(
        '/drivers/call',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'interface': 'puter-kvstore',
          'method': method,
          if (args != null) 'args': args,
        },
      );

      if (response.statusCode == 200) {
        final body = response.data;
        if (body is Map && body['success'] == true) {
          return body['result'];
        }
        if (body is Map && body['error'] != null && (body['code'] == 'not_found' || body['code'] == 'key_not_found')) {
          return null;
        }
        return body;
      }

      return null;
    } on AiException {
      rethrow;
    } catch (_) {
      return null;
    }
  }

  // ──────────────────────────────────────────
  // Generic KV operations
  // ──────────────────────────────────────────

  /// Store a JSON-serializable value under a key.
  Future<bool> set({
    required String token,
    required String key,
    required dynamic value,
  }) async {
    if (token.isEmpty) return false;

    final result = await _driverCall(
      token: token,
      method: 'set',
      args: {'key': key, 'value': jsonEncode(value)},
    );

    return result == true;
  }

  /// Retrieve a stored value by key. Returns null if not found.
  Future<dynamic> get({
    required String token,
    required String key,
  }) async {
    if (token.isEmpty) return null;

    final result = await _driverCall(
      token: token,
      method: 'get',
      args: {'key': key},
    );

    if (result == null) return null;
    if (result is String) {
      try {
        return jsonDecode(result);
      } catch (_) {
        return result;
      }
    }
    return result;
  }

  /// Delete a key from the KV store.
  Future<bool> del({
    required String token,
    required String key,
  }) async {
    if (token.isEmpty) return false;

    await _driverCall(
      token: token,
      method: 'del',
      args: {'key': key},
    );

    return true;
  }

  /// List all keys matching a prefix.
  Future<List<String>> listKeys({
    required String token,
    String prefix = '',
  }) async {
    if (token.isEmpty) return [];

    final result = await _driverCall(
      token: token,
      method: 'list',
      args: {'prefix': prefix, 'count': 200},
    );

    if (result is List) {
      return result
          .whereType<Map>()
          .map((item) => item['key']?.toString() ?? '')
          .where((k) => k.isNotEmpty)
          .toList();
    }
    return [];
  }

  // ──────────────────────────────────────────
  // Domain-specific helpers
  // ──────────────────────────────────────────

  String _docKey(String docId) => '$_prefix/documents/$docId';
  String _folderKey(String folderId) => '$_prefix/folders/$folderId';
  String _highlightsKey(String docId) => '$_prefix/highlights/$docId';
  String _notesKey(String docId) => '$_prefix/notes/$docId';
  String _chatKey(String docId) => '$_prefix/chat/$docId';
  String _summariesKey(String docId) => '$_prefix/summaries/$docId';
  String _canvasKey(String docId) => '$_prefix/canvas/$docId';
  static const String _settingsKey = '$_prefix/settings';

  Future<bool> saveDocument(String token, String docId, Map<String, dynamic> meta) =>
      set(token: token, key: _docKey(docId), value: meta);

  Future<Map<String, dynamic>?> getDocument(String token, String docId) async {
    final result = await get(token: token, key: _docKey(docId));
    if (result is Map) return Map<String, dynamic>.from(result);
    return null;
  }

  Future<bool> deleteDocument(String token, String docId) =>
      del(token: token, key: _docKey(docId));

  Future<bool> saveFolder(String token, String folderId, Map<String, dynamic> meta) =>
      set(token: token, key: _folderKey(folderId), value: meta);

  Future<Map<String, dynamic>?> getFolder(String token, String folderId) async {
    final result = await get(token: token, key: _folderKey(folderId));
    if (result is Map) return Map<String, dynamic>.from(result);
    return null;
  }

  Future<bool> deleteFolder(String token, String folderId) =>
      del(token: token, key: _folderKey(folderId));

  Future<bool> saveHighlights(String token, String docId, List highlights) =>
      set(token: token, key: _highlightsKey(docId), value: highlights);

  Future<List> getHighlights(String token, String docId) async {
    final result = await get(token: token, key: _highlightsKey(docId));
    if (result is List) return result;
    return [];
  }

  Future<bool> saveNotes(String token, String docId, List notes) =>
      set(token: token, key: _notesKey(docId), value: notes);

  Future<List> getNotes(String token, String docId) async {
    final result = await get(token: token, key: _notesKey(docId));
    if (result is List) return result;
    return [];
  }

  Future<bool> saveChatHistory(String token, String docId, List messages) =>
      set(token: token, key: _chatKey(docId), value: messages);

  Future<List> getChatHistory(String token, String docId) async {
    final result = await get(token: token, key: _chatKey(docId));
    if (result is List) return result;
    return [];
  }

  Future<bool> saveSummaries(String token, String docId, List summaries) =>
      set(token: token, key: _summariesKey(docId), value: summaries);

  Future<List> getSummaries(String token, String docId) async {
    final result = await get(token: token, key: _summariesKey(docId));
    if (result is List) return result;
    return [];
  }

  Future<bool> saveCanvasCards(String token, String docId, List cards) =>
      set(token: token, key: _canvasKey(docId), value: cards);

  Future<List> getCanvasCards(String token, String docId) async {
    final result = await get(token: token, key: _canvasKey(docId));
    if (result is List) return result;
    return [];
  }

  Future<bool> saveSettings(String token, Map<String, dynamic> settings) =>
      set(token: token, key: _settingsKey, value: settings);

  Future<Map<String, dynamic>?> getSettings(String token) async {
    final result = await get(token: token, key: _settingsKey);
    if (result is Map) return Map<String, dynamic>.from(result);
    return null;
  }

  Future<List<String>> listDocumentIds(String token) async {
    final keys = await listKeys(token: token, prefix: '$_prefix/documents/');
    return keys.map((k) => k.replaceFirst('$_prefix/documents/', '')).toList();
  }

  Future<List<String>> listFolderIds(String token) async {
    final keys = await listKeys(token: token, prefix: '$_prefix/folders/');
    return keys.map((k) => k.replaceFirst('$_prefix/folders/', '')).toList();
  }
}
