/// Abstract AI service interface for text extraction, summarization, and Q&A.
abstract class AIService {
  /// Extract text from document pages.
  Future<String> extractText(List<String> pageImages);

  /// Summarize document content.
  Future<String> summarize({
    required String documentText,
    required String scope, // 'page', 'section', 'selection'
    String? selectedText,
  });

  /// Answer a question about a document.
  Future<AIChatResponse> chat({
    required String documentText,
    required String question,
    List<AIChatMessage>? chatHistory,
  });

  /// Check remaining rate limit queries.
  Future<int> getRemainingQueries();
}

/// A single chat message.
class AIChatMessage {
  const AIChatMessage({
    required this.role,
    required this.content,
    this.citations,
    this.timestamp,
  });

  final String role; // 'user' or 'assistant'
  final String content;
  final List<String>? citations;
  final DateTime? timestamp;
}

/// AI chat response with citations.
class AIChatResponse {
  const AIChatResponse({
    required this.answer,
    this.citations = const [],
    this.confidence,
  });

  final String answer;
  final List<String> citations;
  final double? confidence;
}
