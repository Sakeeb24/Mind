import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindspace/features/ai_chat/domain/entities/chat_message.dart';
import 'package:mindspace/services/ai/ai_service.dart';
import 'package:mindspace/services/ai/nemotron_service.dart';

/// Chat state.
class ChatState {
  const ChatState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
    this.remainingQueries = 20,
  });

  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;
  final int remainingQueries;

  ChatState copyWith({List<ChatMessage>? messages, bool? isLoading, String? error, int? remainingQueries}) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      remainingQueries: remainingQueries ?? this.remainingQueries,
    );
  }
}

/// Chat notifier managing message history and AI responses.
class ChatNotifier extends Notifier<ChatState> {
  @override
  ChatState build() => const ChatState();

  Future<void> sendMessage({
    required String documentId,
    required String documentText,
    required String question,
  }) async {
    // Check rate limit
    if (state.remainingQueries <= 0) {
      state = state.copyWith(error: 'Daily AI limit reached.');
      return;
    }

    // Add user message
    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      documentId: documentId,
      role: 'user',
      content: question,
      createdAt: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
      error: null,
    );

    try {
      final aiService = MockAIService();
      final chatHistory = state.messages
          .where((m) => m.documentId == documentId)
          .map((m) => AIChatMessage(role: m.role, content: m.content))
          .toList();

      final response = await aiService.chat(
        documentText: documentText,
        question: question,
        chatHistory: chatHistory,
      );

      final assistantMessage = ChatMessage(
        id: '${DateTime.now().millisecondsSinceEpoch}_ai',
        documentId: documentId,
        role: 'assistant',
        content: response.answer,
        citations: response.citations,
        modelUsed: 'Nemotron 3 Ultra 550B',
        createdAt: DateTime.now(),
      );

      state = state.copyWith(
        messages: [...state.messages, assistantMessage],
        isLoading: false,
        remainingQueries: state.remainingQueries - 1,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to get response. Please try again.',
      );
    }
  }

  void clearChat() {
    state = const ChatState();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final chatProvider = NotifierProvider<ChatNotifier, ChatState>(
  ChatNotifier.new,
);
