import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindspace/config/theme.dart';
import 'package:mindspace/features/dashboard/domain/entities/document.dart';
import 'package:mindspace/features/summarization/presentation/screens/summary_screen.dart';

Widget buildTestApp(Document doc) {
  return ProviderScope(
    child: MaterialApp(
      theme: AppTheme.light,
      home: SummaryScreen(document: doc),
    ),
  );
}

void main() {
  final testDoc = Document(
    id: 'test-doc',
    title: 'Summary Test Doc',
    fileName: 'test.pdf',
    filePath: '/test.pdf',
    createdAt: DateTime.utc(2024),
  );

  group('SummaryScreen', () {
    testWidgets('shows AI Summary title', (tester) async {
      await tester.pumpWidget(buildTestApp(testDoc));
      await tester.pumpAndSettle();
      expect(find.text('AI Summary'), findsOneWidget);
    });

    testWidgets('shows scope selector', (tester) async {
      await tester.pumpWidget(buildTestApp(testDoc));
      await tester.pumpAndSettle();
      expect(find.text('This Page'), findsOneWidget);
      expect(find.text('Section'), findsOneWidget);
      expect(find.text('Selection'), findsOneWidget);
    });

    testWidgets('shows generate button', (tester) async {
      await tester.pumpWidget(buildTestApp(testDoc));
      await tester.pumpAndSettle();
      expect(find.text('Generate Summary'), findsOneWidget);
    });

    testWidgets('shows remaining queries text', (tester) async {
      await tester.pumpWidget(buildTestApp(testDoc));
      await tester.pumpAndSettle();
      expect(find.textContaining('AI queries remaining'), findsOneWidget);
    });
  });
}
