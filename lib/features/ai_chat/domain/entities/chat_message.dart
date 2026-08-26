class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.documentId,
    required this.role,
    required this.content,
    this.citations,
    this.modelUsed,
    required this.createdAt,
  });

  final String id;
  final String documentId;
  final String role; // 'user' or 'assistant'
  final String content;
  final List<String>? citations;
  final String? modelUsed;
  final DateTime createdAt;

  ChatMessage copyWith({String? content, List<String>? citations}) {
    return ChatMessage(
      id: id,
      documentId: documentId,
      role: role,
      content: content ?? this.content,
      citations: citations ?? this.citations,
      modelUsed: modelUsed,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'documentId': documentId,
        'role': role,
        'content': content,
        'citations': citations,
        'modelUsed': modelUsed,
        'createdAt': createdAt.toIso8601String(),
      };

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id']?.toString() ?? '',
      documentId: json['documentId']?.toString() ?? '',
      role: json['role']?.toString() ?? 'user',
      content: json['content']?.toString() ?? '',
      citations: (json['citations'] as List?)?.map((e) => e.toString()).toList(),
      modelUsed: json['modelUsed']?.toString(),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatMessage && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
