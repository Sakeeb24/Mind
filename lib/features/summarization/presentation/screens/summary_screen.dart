import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.auto_awesome, size: 16, color: AppColors.cyanGlow),
            const SizedBox(width: 8),
            Text(
              'AI Summary',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Scope Selector Header
            Text(
              'SUMMARIZE SCOPE',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextTertiary,
              ),
            ),
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

            // Generate Button
            AppButton(
              onPressed: summaryState.isLoading
                  ? null
                  : () => ref.read(summaryProvider.notifier).summarize(
                        documentId: widget.document.id,
                        documentText: 'Document text for ${widget.document.title}',
                        scope: _selectedScope,
                      ),
              label: summaryState.isLoading ? 'Generating...' : 'Generate Summary',
              isLoading: summaryState.isLoading,
              isExpanded: true,
            ),
            const SizedBox(height: 16),

            // Error container
            if (summaryState.error != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.error.withAlpha(20),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.error.withAlpha(50)),
                ),
                child: Text(
                  summaryState.error!,
                  style: GoogleFonts.plusJakartaSans(color: AppColors.error, fontSize: 13),
                ),
              ),

            // Summary Result Card
            if (summaryState.summary != null) ...[
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? AppColors.whisperBorder : AppColors.lightDivider,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.auto_awesome, size: 14, color: AppColors.cyanGlow),
                              const SizedBox(width: 6),
                              Text(
                                'Key Takeaways',
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withAlpha(30),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              summaryState.summary!.modelUsed,
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.cyanGlow : AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(height: 1),
                      const SizedBox(height: 12),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            summaryState.summary!.content,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              height: 1.55,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                          ),
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
                        Clipboard.setData(ClipboardData(text: summaryState.summary!.content));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Summary copied to clipboard'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      label: 'Copy Summary',
                      variant: AppButtonVariant.secondary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Ready for study notes export'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      label: 'Share / Export',
                      variant: AppButtonVariant.secondary,
                    ),
                  ),
                ],
              ),
            ],

            // Remaining Queries Footer
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6),
              alignment: Alignment.center,
              child: Text(
                'AI queries remaining today: ${summaryState.remainingQueries}',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
