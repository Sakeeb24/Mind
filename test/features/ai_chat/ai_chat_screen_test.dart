import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindspace/config/theme.dart';
import 'package:mindspace/features/ai_chat/presentation/screens/ai_chat_screen.dart';
import 'package:mindspace/features/dashboard/domain/entities/document.dart';

Widget buildTestApp(Document doc) {
  return ProviderScope(
    child: MaterialApp(
      theme: AppTheme.light,
      home: AiChatScreen(document: doc),
    ),
  );
}

void main() {
  final testDoc = Document(
    id: 'test-doc',
    title: 'AI Test Doc',
    fileName: 'test.pdf',
    filePath: '/test.pdf',
    createdAt: DateTime.utc(2024),
  );

  group('AiChatScreen', () {
    testWidgets('shows AI Chat title', (tester) async {
      await tester.pumpWidget(buildTestApp(testDoc));
      await tester.pumpAndSettle();
      expect(find.text('AI Chat'), findsOneWidget);
    });

    testWidgets('shows document title in subtitle', (tester) async {
      await tester.pumpWidget(buildTestApp(testDoc));
      await tester.pumpAndSettle();
      expect(find.text('AI Test Doc'), findsOneWidget);
    });

    testWidgets('shows empty state prompt', (tester) async {
      await tester.pumpWidget(buildTestApp(testDoc));
      await tester.pumpAndSettle();
      expect(find.text('Ask anything'), findsOneWidget);
    });

    testWidgets('shows input bar', (tester) async {
      await tester.pumpWidget(buildTestApp(testDoc));
      await tester.pumpAndSettle();
      expect(find.text('Ask about this document...'), findsOneWidget);
    });

    testWidgets('shows send button', (tester) async {
      await tester.pumpWidget(buildTestApp(testDoc));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.send), findsOneWidget);
    });
  });
}
