import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:mindspace/config/env.dart';
import 'package:mindspace/services/ai/ai_service.dart';
import 'package:mindspace/services/ai/puter_ai_service.dart';

/// Provider for Dio instance used by the AI service.
final dioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      baseUrl: Env.puterApiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );
});

/// Provider for the AI service — uses Puter's OpenAI-compatible endpoint.
/// Supports 500+ models (GPT, Claude, Gemini, Grok, etc.) with no API key management.
final aiServiceProvider = Provider<AIService>((ref) {
  final dio = ref.read(dioProvider);

  // Override the token in env.dart with the auth token if available
  // The PuterAIService reads from Env.puterAuthToken which is a compile-time const.
  // We need to pass the actual auth token dynamically.
  return PuterAIService(dio);
});
