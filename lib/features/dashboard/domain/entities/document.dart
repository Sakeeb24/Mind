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

  String get fileSizeFormatted {
    if (fileSizeBytes < 1024) return '$fileSizeBytes B';
    if (fileSizeBytes < 1024 * 1024) return '${(fileSizeBytes / 1024).toStringAsFixed(1)} KB';
    return '${(fileSizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
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
