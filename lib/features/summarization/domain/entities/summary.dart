class Summary {
  const Summary({
    required this.id,
    required this.documentId,
    required this.scope,
    required this.content,
    required this.modelUsed,
    required this.createdAt,
    this.scopeReference,
  });

  final String id;
  final String documentId;
  final String scope; // 'page', 'section', 'selection'
  final String? scopeReference;
  final String content;
  final String modelUsed;
  final DateTime createdAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Summary && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
