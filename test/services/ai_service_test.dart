import 'package:flutter_test/flutter_test.dart';
import 'package:mindspace/services/ai/nemotron_service.dart';

void main() {
  group('MockAIService', () {
    late MockAIService service;

    setUp(() {
      service = MockAIService();
    });

    test('extractText returns simulated text', () async {
      final result = await service.extractText(['image1', 'image2']);
      expect(result, contains('2 pages'));
      expect(result, isNotEmpty);
    });

    test('summarize returns summary for page scope', () async {
      final result = await service.summarize(
        documentText: 'This is a test document about Flutter development',
        scope: 'page',
      );
      expect(result, contains('Summary (page)'));
      expect(result, isNotEmpty);
    });

    test('summarize returns summary for selection scope', () async {
      final result = await service.summarize(
        documentText: 'Full document text here',
        scope: 'selection',
        selectedText: 'Selected portion of text',
      );
      expect(result, contains('selection'));
    });

    test('chat returns response with citations', () async {
      final result = await service.chat(
        documentText: 'Document about AI',
        question: 'What is AI?',
      );
      expect(result.answer, isNotEmpty);
      expect(result.citations, isNotEmpty);
      expect(result.confidence, greaterThan(0));
    });

    test('getRemainingQueries returns count', () async {
      final count = await service.getRemainingQueries();
      expect(count, greaterThanOrEqualTo(0));
    });
  });
}
