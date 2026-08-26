import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindspace/services/ai/ai_service.dart';
import 'package:mindspace/services/ai/nemotron_service.dart';

void main() {
  group('NemotronAIService & Study Models', () {
    late NemotronAIService service;
    late Dio dio;

    setUp(() {
      dio = Dio(BaseOptions(baseUrl: 'https://mock.supabase.co'));
      service = NemotronAIService(dio);
    });

    test('FormulaDefinition model instantiation', () {
      const formula = FormulaDefinition(
        id: 'f-1',
        title: 'Attention Mechanism',
        formulaOrDefinition: r'\text{Attention}(Q, K, V) = \text{softmax}\left(\frac{QK^T}{\sqrt{d_k}}\right)V',
        explanation: 'Computes scaled dot-product attention across Query, Key, and Value vectors.',
        type: 'formula',
        pageNumber: 3,
      );

      expect(formula.id, 'f-1');
      expect(formula.title, 'Attention Mechanism');
      expect(formula.type, 'formula');
      expect(formula.pageNumber, 3);
      expect(formula.formulaOrDefinition, contains('softmax'));
    });

    test('FlashcardItem model instantiation', () {
      const card = FlashcardItem(
        id: 'fc-1',
        question: 'What does Self-Attention allow a model to do?',
        answer: 'Relate different positions of a single sequence in order to compute a representation.',
        keyConcept: 'Self-Attention',
        pageNumber: 4,
      );

      expect(card.id, 'fc-1');
      expect(card.question, contains('Self-Attention'));
      expect(card.answer, isNotEmpty);
      expect(card.pageNumber, 4);
    });

    test('QuizQuestionItem model instantiation', () {
      const quizQ = QuizQuestionItem(
        id: 'q-1',
        question: 'Why is the dot product scaled by 1/sqrt(d_k)?',
        options: [
          'To prevent vanishing gradients for large dimensions',
          'To make matrix multiplication faster',
          'To reduce memory footprint',
          'To normalize output logits to zero',
        ],
        correctIndex: 0,
        explanation: 'For large values of d_k, dot products grow large in magnitude, pushing softmax into regions with small gradients.',
        pageNumber: 4,
      );

      expect(quizQ.id, 'q-1');
      expect(quizQ.options.length, 4);
      expect(quizQ.correctIndex, 0);
      expect(quizQ.explanation, contains('softmax'));
    });

    test('Fallback logic generates structured flashcards on offline/failure', () async {
      final cards = await service.generateFlashcards(
        documentText: 'Document: Transformer Architecture\nPages: 10',
        count: 5,
      );

      expect(cards.length, 5);
      expect(cards.first.question, isNotEmpty);
      expect(cards.first.answer, isNotEmpty);
    });

    test('Fallback logic generates structured quiz questions on offline/failure', () async {
      final quiz = await service.generateQuiz(
        documentText: 'Document: Quantum Computing\nPages: 8',
        questionCount: 5,
      );

      expect(quiz.length, 5);
      expect(quiz.first.options.length, 4);
      expect(quiz.first.correctIndex, inInclusiveRange(0, 3));
    });

    test('Fallback logic extracts formulas and definitions on offline/failure', () async {
      final formulas = await service.extractFormulasAndDefinitions(
        documentText: 'Document: Deep Learning Foundations\nPages: 12',
        pageNumber: 2,
      );

      expect(formulas, isNotEmpty);
      expect(formulas.first.title, isNotEmpty);
      expect(formulas.first.formulaOrDefinition, isNotEmpty);
    });
  });
}
