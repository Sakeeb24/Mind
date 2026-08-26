import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mindspace/config/theme.dart';
import 'package:mindspace/features/ai_chat/presentation/providers/chat_provider.dart';
import 'package:mindspace/features/ai_chat/presentation/widgets/chat_bubble.dart';
import 'package:mindspace/features/ai_chat/presentation/widgets/chat_input_bar.dart';
import 'package:mindspace/features/ai_chat/presentation/widgets/typing_indicator.dart';
import 'package:mindspace/features/dashboard/domain/entities/document.dart';
import 'package:mindspace/features/document_viewer/presentation/widgets/study_features_dialogs.dart';
import 'package:mindspace/services/ai/ai_usage_tracker.dart';

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

  void _sendPrompt(String prompt) {
    ref.read(chatProvider.notifier).sendMessage(
          documentId: widget.document.id,
          documentText: 'Document: ${widget.document.title}\nPages: ${widget.document.pageCount}',
          question: prompt,
        );
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    ref.listen<ChatState>(chatProvider, (prev, next) {
      if (next.messages.length > (prev?.messages.length ?? 0)) {
        _scrollToBottom();
      }
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
        ref.read(chatProvider.notifier).clearError();
      }
    });

    final messages = chatState.messages
        .where((m) => m.documentId == widget.document.id)
        .toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.obsidian : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.navySlate : AppColors.lightSurface,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(isDark ? 40 : 20),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.auto_awesome, size: 16, color: AppColors.cyanGlow),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI Chat',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  Text(
                    widget.document.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          // Remaining Query Badge
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceContainerLow : AppColors.lightSurfaceVariant,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.whisperBorder : AppColors.lightDivider,
                width: 0.8,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.bolt_rounded, size: 13, color: AppColors.amberGold),
                const SizedBox(width: 4),
                Text(
                  '${AiUsageTracker.getRemaining()}/20',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (messages.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined, size: 20),
              onPressed: () => ref.read(chatProvider.notifier).clearChat(),
              tooltip: 'Clear chat session',
            ),
        ],
      ),
      body: Column(
        children: [
          // Quick Action Suggestion Chips
          Container(
            height: 46,
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceContainerLow : AppColors.lightSurfaceVariant,
              border: Border(
                bottom: BorderSide(
                  color: isDark ? AppColors.whisperBorder : AppColors.lightDivider,
                  width: 0.8,
                ),
              ),
            ),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _buildQuickChip(
                  label: '✦ Summarize Doc',
                  icon: Icons.summarize_outlined,
                  onTap: () => StudyFeaturesDialogs.showSummaryDialog(
                    context: context,
                    ref: ref,
                    document: widget.document,
                  ),
                  isDark: isDark,
                ),
                _buildQuickChip(
                  label: '✦ Formulas & Definitions',
                  icon: Icons.calculate_outlined,
                  onTap: () => StudyFeaturesDialogs.showFormulasDialog(
                    context: context,
                    ref: ref,
                    document: widget.document,
                  ),
                  isDark: isDark,
                ),
                _buildQuickChip(
                  label: '✦ Generate 5 Flashcards',
                  icon: Icons.style_outlined,
                  onTap: () => StudyFeaturesDialogs.showFlashcardsDialog(
                    context: context,
                    ref: ref,
                    document: widget.document,
                  ),
                  isDark: isDark,
                ),
                _buildQuickChip(
                  label: '✦ Quiz Me',
                  icon: Icons.quiz_outlined,
                  onTap: () => StudyFeaturesDialogs.showQuizDialog(
                    context: context,
                    ref: ref,
                    document: widget.document,
                  ),
                  isDark: isDark,
                ),
              ],
            ),
          ),

          // Message Stream
          Expanded(
            child: messages.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withAlpha(isDark ? 30 : 15),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primary.withAlpha(60),
                                width: 1,
                              ),
                            ),
                            child: const Icon(
                              Icons.auto_awesome,
                              size: 36,
                              color: AppColors.cyanGlow,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Ask anything',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Puter AI will provide grounded explanations, formula breakdowns, and source citations.',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              height: 1.4,
                            ),
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

          // Input Bar
          ChatInputBar(
            isLoading: chatState.isLoading,
            onSend: (question) => _sendPrompt(question),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickChip({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isDark ? AppColors.navySlate : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.whisperBorder : AppColors.lightDivider,
                width: 0.8,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 12, color: AppColors.cyanGlow),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.cyanGlow : AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
