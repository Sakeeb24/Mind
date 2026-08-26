enum CanvasCardType {
  textExcerpt,
  stickyNote,
  aiSummary,
  conceptCard,
}

class CanvasCard {
  const CanvasCard({
    required this.id,
    required this.documentId,
    required this.type,
    required this.content,
    this.title,
    this.pageNumber = 1,
    this.anchorX = 0.5,
    this.anchorY = 0.5,
    this.posX = 50.0,
    this.posY = 50.0,
    this.width = 240.0,
    this.color = '#FFF9C4', // Soft Yellow default
    this.connectedCardIds = const [],
    this.aiExplanation,
    required this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String documentId;
  final CanvasCardType type;
  final String content;
  final String? title;
  final int pageNumber;
  final double anchorX;
  final double anchorY;
  final double posX;
  final double posY;
  final double width;
  final String color;
  final List<String> connectedCardIds;
  final String? aiExplanation;
  final DateTime createdAt;
  final DateTime? updatedAt;

  CanvasCard copyWith({
    String? content,
    String? title,
    int? pageNumber,
    double? anchorX,
    double? anchorY,
    double? posX,
    double? posY,
    double? width,
    String? color,
    List<String>? connectedCardIds,
    String? aiExplanation,
    DateTime? updatedAt,
  }) {
    return CanvasCard(
      id: id,
      documentId: documentId,
      type: type,
      content: content ?? this.content,
      title: title ?? this.title,
      pageNumber: pageNumber ?? this.pageNumber,
      anchorX: anchorX ?? this.anchorX,
      anchorY: anchorY ?? this.anchorY,
      posX: posX ?? this.posX,
      posY: posY ?? this.posY,
      width: width ?? this.width,
      color: color ?? this.color,
      connectedCardIds: connectedCardIds ?? this.connectedCardIds,
      aiExplanation: aiExplanation ?? this.aiExplanation,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'documentId': documentId,
      'type': type.name,
      'content': content,
      'title': title,
      'pageNumber': pageNumber,
      'anchorX': anchorX,
      'anchorY': anchorY,
      'posX': posX,
      'posY': posY,
      'width': width,
      'color': color,
      'connectedCardIds': connectedCardIds,
      'aiExplanation': aiExplanation,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory CanvasCard.fromMap(Map<dynamic, dynamic> map) {
    return CanvasCard(
      id: map['id'] as String,
      documentId: map['documentId'] as String,
      type: CanvasCardType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => CanvasCardType.textExcerpt,
      ),
      content: map['content'] as String? ?? '',
      title: map['title'] as String?,
      pageNumber: map['pageNumber'] as int? ?? 1,
      anchorX: (map['anchorX'] as num?)?.toDouble() ?? 0.5,
      anchorY: (map['anchorY'] as num?)?.toDouble() ?? 0.5,
      posX: (map['posX'] as num?)?.toDouble() ?? 50.0,
      posY: (map['posY'] as num?)?.toDouble() ?? 50.0,
      width: (map['width'] as num?)?.toDouble() ?? 240.0,
      color: map['color'] as String? ?? '#FFF9C4',
      connectedCardIds: (map['connectedCardIds'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      aiExplanation: map['aiExplanation'] as String?,
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ?? DateTime.now(),
      updatedAt: map['updatedAt'] != null ? DateTime.tryParse(map['updatedAt'] as String) : null,
    );
  }
}
