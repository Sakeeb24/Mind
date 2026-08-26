import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';
import 'package:mindspace/config/constants.dart';
import 'package:mindspace/features/ai_chat/domain/entities/chat_message.dart';
import 'package:mindspace/features/auth/presentation/providers/auth_provider.dart';
import 'package:mindspace/providers/ai_service_provider.dart';
import 'package:mindspace/providers/cloud_providers.dart';
import 'package:mindspace/services/ai/ai_service.dart';
import 'package:mindspace/services/ai/ai_usage_tracker.dart';

/// Chat state.
class ChatState {
  const ChatState({this.messages = const [], this.isLoading = false, this.error});

  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;

  ChatState copyWith({List<ChatMessage>? messages, bool? isLoading, String? error}) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Chat notifier managing message history and AI responses.
/// Persists messages to Hive and syncs with Puter KV.
class ChatNotifier extends StateNotifier<ChatState> {
  final AIService _aiService;
  final Ref _ref;

  ChatNotifier(this._aiService, this._ref) : super(const ChatState());

  /// Load chat history for a document from Hive.
  Future<void> loadChatHistory(String documentId) async {
    try {
      final box = Hive.box(AppConstants.chatHistoryBox);
      final stored = box.get(documentId);
      if (stored is List && stored.isNotEmpty) {
        final messages = stored
            .whereType<Map>()
            .map((m) {
              try {
                return ChatMessage.fromJson(Map<String, dynamic>.from(m));
              } catch (_) {
                return null;
              }
            })
            .whereType<ChatMessage>()
            .toList();
        if (messages.isNotEmpty) {
          state = state.copyWith(messages: messages);
        }
      }
    } catch (_) {
      // Non-fatal
    }
  }

  /// Persist current messages for a document to Hive.
  void _persistToHive(String documentId) {
    try {
      final box = Hive.box(AppConstants.chatHistoryBox);
      final jsonList = state.messages
          .where((m) => m.documentId == documentId)
          .map((m) => m.toJson())
          .toList();
      box.put(documentId, jsonList);
    } catch (_) {
      // Non-fatal
    }
  }

  /// Sync chat history to Puter KV in the background.
  void _syncToCloud(String documentId) {
    try {
      final authState = _ref.read(authProvider);
      if (authState.user == null) return;

      final token = _getToken();
      if (token.isEmpty) return;

      final kvService = _ref.read(kvServiceProvider);
      final messages = state.messages
          .where((m) => m.documentId == documentId)
          .map((m) => m.toJson())
          .toList();
      kvService.saveChatHistory(token, documentId, messages);
    } catch (_) {
      // Non-fatal
    }
  }

  String _getToken() {
    try {
      final repo = _ref.read(authRepositoryProvider);
      final dynamic dynRepo = repo;
      return dynRepo.token?.toString() ?? '';
    } catch (_) {
      return '';
    }
  }

  Future<void> sendMessage({
    required String documentId,
    required String documentText,
    required String question,
  }) async {
    if (AiUsageTracker.isLimitReached()) {
      state = state.copyWith(error: 'Daily AI limit reached. Please try again tomorrow.');
      return;
    }

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

    // Persist user message immediately
    _persistToHive(documentId);

    try {
      final chatHistory = state.messages
          .where((m) => m.documentId == documentId)
          .map((m) => AIChatMessage(role: m.role, content: m.content))
          .toList();

      final response = await _aiService.chat(
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
        modelUsed: 'Puter AI',
        createdAt: DateTime.now(),
      );

      state = state.copyWith(
        messages: [...state.messages, assistantMessage],
        isLoading: false,
      );

      // Persist both messages and sync to cloud
      _persistToHive(documentId);
      _syncToCloud(documentId);
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

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier(ref.read(aiServiceProvider), ref);
});
