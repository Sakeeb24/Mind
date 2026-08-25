import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindspace/config/theme.dart';
import 'package:mindspace/core/widgets/app_button.dart';
import 'package:mindspace/features/dashboard/domain/entities/document.dart';
import 'package:mindspace/features/summarization/presentation/providers/summary_provider.dart';

class SummaryScreen extends ConsumerStatefulWidget {
  const SummaryScreen({super.key, required this.document});

  final Document document;

  @override
  ConsumerState<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends ConsumerState<SummaryScreen> {
  String _selectedScope = 'page';

  @override
  Widget build(BuildContext context) {
    final summaryState = ref.watch(summaryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('AI Summary')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Scope selector
            Text('Summarize:', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'page', label: Text('This Page')),
                ButtonSegment(value: 'section', label: Text('Section')),
                ButtonSegment(value: 'selection', label: Text('Selection')),
              ],
              selected: {_selectedScope},
              onSelectionChanged: (s) => setState(() => _selectedScope = s.first),
            ),
            const SizedBox(height: 16),
            // Generate button
            AppButton(
              onPressed: summaryState.isLoading
                  ? null
                  : () => ref.read(summaryProvider.notifier).summarize(
                        documentId: widget.document.id,
                        documentText: 'Sample document text for ${widget.document.title}',
                        scope: _selectedScope,
                      ),
              label: summaryState.isLoading ? 'Generating...' : 'Generate Summary',
              isLoading: summaryState.isLoading,
              isExpanded: true,
            ),
            const SizedBox(height: 16),
            // Error
            if (summaryState.error != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.error.withAlpha(20),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(summaryState.error!, style: TextStyle(color: AppColors.error)),
              ),
            // Summary result
            if (summaryState.summary != null) ...[
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.lightSurface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Summary', style: Theme.of(context).textTheme.titleSmall),
                          Text(
                            summaryState.summary!.modelUsed,
                            style: TextStyle(fontSize: 11, color: AppColors.lightTextTertiary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(summaryState.summary!.content),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      onPressed: () {
                        // Copy to clipboard
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Copied to clipboard')),
                        );
                      },
                      label: 'Copy',
                      variant: AppButtonVariant.secondary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton(
                      onPressed: () {
                        // Share
                      },
                      label: 'Share',
                      variant: AppButtonVariant.secondary,
                    ),
                  ),
                ],
              ),
            ],
            // Remaining queries
            const SizedBox(height: 8),
            Text(
              'AI queries remaining today: ${summaryState.remainingQueries}',
              style: TextStyle(fontSize: 12, color: AppColors.lightTextTertiary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
