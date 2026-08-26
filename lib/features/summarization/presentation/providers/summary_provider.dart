import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindspace/features/summarization/domain/entities/summary.dart';
import 'package:mindspace/services/ai/ai_service.dart';
import 'package:mindspace/providers/ai_service_provider.dart';

/// Summary state.
class SummaryState {
  const SummaryState({
    this.summary,
    this.isLoading = false,
    this.error,
    this.remainingQueries = 20,
  });

  final Summary? summary;
  final bool isLoading;
  final String? error;
  final int remainingQueries;

  SummaryState copyWith({Summary? summary, bool? isLoading, String? error, int? remainingQueries}) {
    return SummaryState(
      summary: summary ?? this.summary,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      remainingQueries: remainingQueries ?? this.remainingQueries,
    );
  }
}

/// Summary notifier managing summarization requests and caching.
class SummaryNotifier extends StateNotifier<SummaryState> {
  final AIService _aiService;
  final Map<String, Summary> _cache = {};

  SummaryNotifier(this._aiService) : super(const SummaryState());

  Future<void> summarize({
    required String documentId,
    required String documentText,
    required String scope,
    String? selectedText,
  }) async {
    // Check cache
    final cacheKey = '$documentId:$scope:${selectedText ?? ''}';
    if (_cache.containsKey(cacheKey)) {
      state = state.copyWith(summary: _cache[cacheKey]);
      return;
    }

    // Check rate limit
    if (state.remainingQueries <= 0) {
      state = state.copyWith(error: 'Daily AI limit reached. Please try again tomorrow.');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final content = await _aiService.summarize(
        documentText: documentText,
        scope: scope,
        selectedText: selectedText,
      );

      final summary = Summary(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        documentId: documentId,
        scope: scope,
        content: content,
        modelUsed: 'Nemotron 3 Ultra 550B',
        createdAt: DateTime.now(),
        scopeReference: selectedText,
      );

      _cache[cacheKey] = summary;
      state = state.copyWith(
        summary: summary,
        isLoading: false,
        remainingQueries: state.remainingQueries - 1,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to generate summary. Please try again.',
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final summaryProvider = StateNotifierProvider<SummaryNotifier, SummaryState>((ref) {
  return SummaryNotifier(ref.read(aiServiceProvider));
});