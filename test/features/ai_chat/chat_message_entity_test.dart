import 'package:flutter_test/flutter_test.dart';
import 'package:mindspace/features/ai_chat/domain/entities/chat_message.dart';

void main() {
  final fixedDate = DateTime.utc(2024);

  group('ChatMessage', () {
    test('copyWith preserves unchanged fields', () {
      final m = ChatMessage(
        id: '1', documentId: 'doc1', role: 'user',
        content: 'Hello', citations: ['Page 1'], createdAt: fixedDate,
      );
      final updated = m.copyWith(content: 'Hi there');
      expect(updated.content, 'Hi there');
      expect(updated.role, 'user');
      expect(updated.documentId, 'doc1');
      expect(updated.citations, ['Page 1']);
    });

    test('equality is based on id', () {
      final m1 = ChatMessage(id: '1', documentId: 'd', role: 'user', content: 'a', createdAt: fixedDate);
      final m2 = ChatMessage(id: '1', documentId: 'x', role: 'assistant', content: 'b', createdAt: fixedDate);
      final m3 = ChatMessage(id: '2', documentId: 'd', role: 'user', content: 'a', createdAt: fixedDate);
      expect(m1, equals(m2));
      expect(m1 == m3, isFalse);
    });
  });
}
