class Highlight {
  const Highlight({
    required this.id,
    required this.documentId,
    required this.pageNumber,
    required this.selectedText,
    required this.color,
    required this.startOffset,
    required this.endOffset,
    required this.createdAt,
  });

  final String id;
  final String documentId;
  final int pageNumber;
  final String selectedText;
  final String color;
  final int startOffset;
  final int endOffset;
  final DateTime createdAt;

  Highlight copyWith({String? color, String? selectedText}) {
    return Highlight(
      id: id,
      documentId: documentId,
      pageNumber: pageNumber,
      selectedText: selectedText ?? this.selectedText,
      color: color ?? this.color,
      startOffset: startOffset,
      endOffset: endOffset,
      createdAt: createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Highlight && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
