import 'package:filesize/filesize.dart';

class Document {
  const Document({
    required this.id,
    required this.title,
    required this.fileName,
    required this.filePath,
    this.fileSizeBytes = 0,
    this.pageCount = 0,
    this.thumbnailPath,
    this.folderId,
    this.hasExtractedText = false,
    required this.createdAt,
    this.lastOpenedAt,
  });

  final String id;
  final String title;
  final String fileName;
  final String filePath;
  final int fileSizeBytes;
  final int pageCount;
  final String? thumbnailPath;
  final String? folderId;
  final bool hasExtractedText;
  final DateTime createdAt;
  final DateTime? lastOpenedAt;

  Document copyWith({
    String? title,
    String? folderId,
    bool? hasExtractedText,
    DateTime? lastOpenedAt,
    int? pageCount,
    String? thumbnailPath,
  }) {
    return Document(
      id: id,
      title: title ?? this.title,
      fileName: fileName,
      filePath: filePath,
      fileSizeBytes: fileSizeBytes,
      pageCount: pageCount ?? this.pageCount,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      folderId: folderId ?? this.folderId,
      hasExtractedText: hasExtractedText ?? this.hasExtractedText,
      createdAt: createdAt,
      lastOpenedAt: lastOpenedAt ?? this.lastOpenedAt,
    );
  }

  String get fileSizeFormatted => filesize(fileSizeBytes);

  /// Serialize to a JSON-compatible map for cloud persistence.
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'fileName': fileName,
        'filePath': filePath,
        'fileSizeBytes': fileSizeBytes,
        'pageCount': pageCount,
        'thumbnailPath': thumbnailPath,
        'folderId': folderId,
        'hasExtractedText': hasExtractedText,
        'createdAt': createdAt.toIso8601String(),
        'lastOpenedAt': lastOpenedAt?.toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      };

  /// Deserialize from a JSON map.
  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      fileName: json['fileName']?.toString() ?? '',
      filePath: json['filePath']?.toString() ?? '',
      fileSizeBytes: (json['fileSizeBytes'] as num?)?.toInt() ?? 0,
      pageCount: (json['pageCount'] as num?)?.toInt() ?? 0,
      thumbnailPath: json['thumbnailPath']?.toString(),
      folderId: json['folderId']?.toString(),
      hasExtractedText: json['hasExtractedText'] == true,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
      lastOpenedAt: json['lastOpenedAt'] != null
          ? DateTime.tryParse(json['lastOpenedAt'].toString())
          : null,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Document && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Document(id: $id, title: $title)';
}
