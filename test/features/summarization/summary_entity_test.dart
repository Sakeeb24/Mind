import 'package:flutter_test/flutter_test.dart';
import 'package:mindspace/features/summarization/domain/entities/summary.dart';

void main() {
  final fixedDate = DateTime.utc(2024);

  group('Summary', () {
    test('equality is based on id', () {
      final s1 = Summary(id: '1', documentId: 'd', scope: 'page', content: 'Hello', modelUsed: 'Ultra', createdAt: fixedDate);
      final s2 = Summary(id: '1', documentId: 'x', scope: 'section', content: 'World', modelUsed: 'Nano', createdAt: fixedDate);
      final s3 = Summary(id: '2', documentId: 'd', scope: 'page', content: 'Hello', modelUsed: 'Ultra', createdAt: fixedDate);
      expect(s1, equals(s2));
      expect(s1 == s3, isFalse);
    });
  });
}
