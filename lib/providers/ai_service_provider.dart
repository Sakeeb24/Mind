import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:mindspace/config/env.dart';
import 'package:mindspace/services/ai/ai_service.dart';
import 'package:mindspace/services/ai/nemotron_service.dart';

/// Provider for Dio instance used by Nemotron AI service.
final dioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      baseUrl: Env.supabaseUrl,
      headers: {
        'apikey': Env.supabaseAnonKey,
        'Authorization': 'Bearer ${Env.supabaseAnonKey}',
        'Content-Type': 'application/json',
      },
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );
});

/// Provider for the AI service (Nemotron implementation).
final aiServiceProvider = Provider<AIService>((ref) {
  return NemotronAIService(ref.read(dioProvider));
});