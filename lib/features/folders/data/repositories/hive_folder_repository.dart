import 'dart:convert';

import 'package:hive_ce/hive.dart';
import 'package:mindspace/features/folders/domain/entities/folder.dart';
import 'package:mindspace/features/folders/domain/repositories/folder_repository.dart';

class HiveFolderRepository implements FolderRepository {
  HiveFolderRepository(this._box);

  final Box _box;

  @override
  Future<List<Folder>> getAllFolders() async {
    return _box.values.map((e) => _fromMap(Map<String, dynamic>.from(jsonDecode(e as String)))).toList();
  }

  @override
  Future<Folder?> getFolderById(String id) async {
    final data = _box.get(id);
    if (data == null) return null;
    return _fromMap(Map<String, dynamic>.from(jsonDecode(data as String)));
  }

  @override
  Future<Folder> addFolder(Folder folder) async {
    await _box.put(folder.id, jsonEncode(_toMap(folder)));
    return folder;
  }

  @override
  Future<void> updateFolder(Folder folder) async {
    await _box.put(folder.id, jsonEncode(_toMap(folder)));
  }

  @override
  Future<void> deleteFolder(String id) async {
    await _box.delete(id);
  }

  Map<String, dynamic> _toMap(Folder f) => {
        'id': f.id,
        'name': f.name,
        'color': f.color,
        'parentId': f.parentId,
        'createdAt': f.createdAt.toIso8601String(),
      };

  Folder _fromMap(Map<String, dynamic> m) => Folder(
        id: m['id'] as String,
        name: m['name'] as String,
        color: m['color'] as String?,
        parentId: m['parentId'] as String?,
        createdAt: DateTime.parse(m['createdAt'] as String),
      );
}
