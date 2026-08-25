class StickyNote {
  const StickyNote({
    required this.id,
    required this.documentId,
    required this.pageNumber,
    required this.xPosition,
    required this.yPosition,
    required this.content,
    required this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String documentId;
  final int pageNumber;
  final double xPosition;
  final double yPosition;
  final String content;
  final DateTime createdAt;
  final DateTime? updatedAt;

  StickyNote copyWith({String? content, double? xPosition, double? yPosition}) {
    return StickyNote(
      id: id,
      documentId: documentId,
      pageNumber: pageNumber,
      xPosition: xPosition ?? this.xPosition,
      yPosition: yPosition ?? this.yPosition,
      content: content ?? this.content,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StickyNote && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
