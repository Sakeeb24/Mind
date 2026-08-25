import 'package:dio/dio.dart';
import 'package:mindspace/config/env.dart';
import 'package:mindspace/services/ai/ai_service.dart';

/// Nemotron API implementation using Supabase Edge Functions as proxy.
class NemotronAIService implements AIService {
  NemotronAIService(this._dio);

  final Dio _dio;
  final String _baseUrl = Env.supabaseUrl;

  @override
  Future<String> extractText(List<String> pageImages) async {
    final response = await _dio.post(
      '$_baseUrl/functions/v1/extract-text',
      data: {'pageImages': pageImages},
    );
    return response.data['text'] as String;
  }

  @override
  Future<String> summarize({
    required String documentText,
    required String scope,
    String? selectedText,
  }) async {
    final response = await _dio.post(
      '$_baseUrl/functions/v1/summarize',
      data: {
        'documentText': documentText,
        'scope': scope,
        'selectedText': ?selectedText,
      },
    );
    return response.data['summary'] as String;
  }

  @override
  Future<AIChatResponse> chat({
    required String documentText,
    required String question,
    List<AIChatMessage>? chatHistory,
  }) async {
    final response = await _dio.post(
      '$_baseUrl/functions/v1/chat',
      data: {
        'documentText': documentText,
        'question': question,
        if (chatHistory != null)
          'chatHistory': chatHistory
              .map((m) => {'role': m.role, 'content': m.content})
              .toList(),
      },
    );
    return AIChatResponse(
      answer: response.data['answer'] as String,
      citations: (response.data['citations'] as List<dynamic>?)
              ?.map((c) => c.toString())
              .toList() ??
          [],
      confidence: (response.data['confidence'] as num?)?.toDouble(),
    );
  }

  @override
  Future<int> getRemainingQueries() async {
    final response = await _dio.get('$_baseUrl/functions/v1/rate-limit');
    return response.data['queriesRemaining'] as int;
  }
}

/// Mock AI service for testing and offline development.
class MockAIService implements AIService {
  int remainingQueries = 20;

  @override
  Future<String> extractText(List<String> pageImages) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return 'Extracted text from ${pageImages.length} pages. This is simulated text extraction using Nemotron-Parse.';
  }

  @override
  Future<String> summarize({
    required String documentText,
    required String scope,
    String? selectedText,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    final target = selectedText ?? documentText;
    final words = target.split(' ');
    final limit = words.length.clamp(0, 50);
    return 'Summary ($scope): ${words.take(limit).join(' ')}...';
  }

  @override
  Future<AIChatResponse> chat({
    required String documentText,
    required String question,
    List<AIChatMessage>? chatHistory,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return AIChatResponse(
      answer: 'This is a mock response to: "$question". In production, this would be answered by Nemotron 3 Ultra 550B with document context.',
      citations: ['Page 1', 'Page 3'],
      confidence: 0.85,
    );
  }

  @override
  Future<int> getRemainingQueries() async {
    return remainingQueries;
  }
}
