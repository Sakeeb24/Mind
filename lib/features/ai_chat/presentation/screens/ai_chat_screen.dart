import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindspace/config/theme.dart';
import 'package:mindspace/features/ai_chat/presentation/providers/chat_provider.dart';
import 'package:mindspace/features/ai_chat/presentation/widgets/chat_bubble.dart';
import 'package:mindspace/features/ai_chat/presentation/widgets/chat_input_bar.dart';
import 'package:mindspace/features/ai_chat/presentation/widgets/typing_indicator.dart';
import 'package:mindspace/features/dashboard/domain/entities/document.dart';

class AiChatScreen extends ConsumerStatefulWidget {
  const AiChatScreen({super.key, required this.document});

  final Document document;

  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);

    ref.listen<ChatState>(chatProvider, (prev, next) {
      if (next.messages.length > (prev?.messages.length ?? 0)) {
        _scrollToBottom();
      }
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!), backgroundColor: AppColors.error),
        );
        ref.read(chatProvider.notifier).clearError();
      }
    });

    final messages = chatState.messages
        .where((m) => m.documentId == widget.document.id)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('AI Chat', style: TextStyle(fontSize: 16)),
            Text(
              widget.document.title,
              style: TextStyle(fontSize: 12, color: AppColors.lightTextTertiary),
            ),
          ],
        ),
        actions: [
          if (messages.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => ref.read(chatProvider.notifier).clearChat(),
              tooltip: 'Clear chat',
            ),
        ],
      ),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: messages.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.chat_bubble_outline, size: 64, color: AppColors.lightTextTertiary),
                          const SizedBox(height: 16),
                          Text('Ask anything', style: Theme.of(context).textTheme.headlineSmall),
                          const SizedBox(height: 8),
                          Text(
                            'AI will answer based on this document\'s content',
                            style: TextStyle(color: AppColors.lightTextSecondary),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length + (chatState.isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == messages.length) {
                        return const TypingIndicator();
                      }
                      final msg = messages[index];
                      return ChatBubble(
                        message: msg.content,
                        isUser: msg.role == 'user',
                        citations: msg.citations,
                      );
                    },
                  ),
          ),
          // Input bar
          ChatInputBar(
            isLoading: chatState.isLoading,
            onSend: (question) => ref.read(chatProvider.notifier).sendMessage(
                  documentId: widget.document.id,
                  documentText: 'Sample document text for ${widget.document.title}',
                  question: question,
                ),
          ),
        ],
      ),
    );
  }
}
