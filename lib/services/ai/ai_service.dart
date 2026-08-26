/// Abstract AI service interface for text extraction, summarization, Q&A,
/// formulas & definitions extraction, flashcard generation, and quiz synthesis.
abstract class AIService {
  /// Extract text from document pages.
  Future<String> extractText(List<String> pageImages);

  /// Summarize document content.
  Future<String> summarize({
    required String documentText,
    required String scope, // 'page', 'section', 'selection', 'document'
    String? selectedText,
    String? documentId,
    int? pageNumber,
  });

  /// Answer a question about a document.
  Future<AIChatResponse> chat({
    required String documentText,
    required String question,
    List<AIChatMessage>? chatHistory,
    String? documentId,
  });

  /// Extract core formulas, definitions, theorems, and key concepts.
  Future<List<FormulaDefinition>> extractFormulasAndDefinitions({
    required String documentText,
    int? pageNumber,
  });

  /// Generate exactly [count] active-recall study flashcards grounded in document context.
  Future<List<FlashcardItem>> generateFlashcards({
    required String documentText,
    int count = 5,
  });

  /// Generate interactive quiz questions grounded in document context.
  Future<List<QuizQuestionItem>> generateQuiz({
    required String documentText,
    int questionCount = 5,
  });

  /// Provide a clear, deep AI explanation for a specific extracted excerpt.
  Future<String> explainExcerpt({
    required String excerpt,
    required String documentContext,
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
    this.model,
  });

  final String answer;
  final List<String> citations;
  final double? confidence;
  final String? model;
}

/// A structured formula or definition item.
class FormulaDefinition {
  const FormulaDefinition({
    required this.id,
    required this.title,
    required this.formulaOrDefinition,
    required this.explanation,
    required this.type, // 'formula', 'definition', 'theorem', 'concept'
    this.pageNumber,
  });

  final String id;
  final String title;
  final String formulaOrDefinition;
  final String explanation;
  final String type;
  final int? pageNumber;

  factory FormulaDefinition.fromJson(Map<String, dynamic> json, {int? defaultPage}) {
    return FormulaDefinition(
      id: json['id']?.toString() ?? 'fd_${DateTime.now().millisecondsSinceEpoch}',
      title: json['title']?.toString() ?? 'Key Definition',
      formulaOrDefinition: json['formula']?.toString() ?? json['definition']?.toString() ?? json['content']?.toString() ?? '',
      explanation: json['explanation']?.toString() ?? json['description']?.toString() ?? '',
      type: json['type']?.toString() ?? 'concept',
      pageNumber: json['pageNumber'] != null ? int.tryParse(json['pageNumber'].toString()) : defaultPage,
    );
  }
}

/// An active-recall flashcard item.
class FlashcardItem {
  const FlashcardItem({
    required this.id,
    required this.question,
    required this.answer,
    this.keyConcept,
    this.pageNumber,
  });

  final String id;
  final String question;
  final String answer;
  final String? keyConcept;
  final int? pageNumber;

  factory FlashcardItem.fromJson(Map<String, dynamic> json, {int? defaultPage}) {
    return FlashcardItem(
      id: json['id']?.toString() ?? 'fc_${DateTime.now().millisecondsSinceEpoch}',
      question: json['question']?.toString() ?? 'Question',
      answer: json['answer']?.toString() ?? 'Answer',
      keyConcept: json['keyConcept']?.toString() ?? json['topic']?.toString(),
      pageNumber: json['pageNumber'] != null ? int.tryParse(json['pageNumber'].toString()) : defaultPage,
    );
  }
}

/// A multiple-choice quiz question item.
class QuizQuestionItem {
  const QuizQuestionItem({
    required this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    this.pageNumber,
  });

  final String id;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final int? pageNumber;

  factory QuizQuestionItem.fromJson(Map<String, dynamic> json, {int? defaultPage}) {
    final rawOptions = json['options'] as List<dynamic>? ?? [];
    final optionsList = rawOptions.map((o) => o.toString()).toList();
    if (optionsList.isEmpty) {
      optionsList.addAll(['Option A', 'Option B', 'Option C', 'Option D']);
    }

    int parsedCorrectIndex = 0;
    if (json['correctIndex'] != null) {
      parsedCorrectIndex = int.tryParse(json['correctIndex'].toString()) ?? 0;
    } else if (json['answerIndex'] != null) {
      parsedCorrectIndex = int.tryParse(json['answerIndex'].toString()) ?? 0;
    }
    if (parsedCorrectIndex < 0 || parsedCorrectIndex >= optionsList.length) {
      parsedCorrectIndex = 0;
    }

    return QuizQuestionItem(
      id: json['id']?.toString() ?? 'quiz_${DateTime.now().millisecondsSinceEpoch}',
      question: json['question']?.toString() ?? 'Question',
      options: optionsList,
      correctIndex: parsedCorrectIndex,
      explanation: json['explanation']?.toString() ?? 'Correct based on document text.',
      pageNumber: json['pageNumber'] != null ? int.tryParse(json['pageNumber'].toString()) : defaultPage,
    );
  }
}
