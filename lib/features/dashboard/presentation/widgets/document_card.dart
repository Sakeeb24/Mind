import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mindspace/config/theme.dart';
import 'package:mindspace/features/dashboard/domain/entities/document.dart';

class DocumentCard extends StatelessWidget {
  const DocumentCard({
    super.key,
    required this.document,
    this.onTap,
    this.onLongPress,
    this.onSummaryTap,
    this.onChatTap,
  });

  final Document document;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onSummaryTap;
  final VoidCallback? onChatTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Semantics(
      label: 'Document: ${document.title}',
      button: true,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.navySlate : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.whisperBorder : AppColors.lightDivider,
            width: 1,
          ),
          boxShadow: AppDecorations.softShadow,
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Banner Area
              Expanded(
                flex: 5,
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.surfaceContainerLow
                        : AppColors.lightSurfaceVariant,
                    border: Border(
                      bottom: BorderSide(
                        color: isDark ? AppColors.whisperBorder : AppColors.lightDivider,
                        width: 0.8,
                      ),
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Ambient Watermark
                      Positioned(
                        right: -8,
                        bottom: -8,
                        child: Icon(
                          Icons.picture_as_pdf_rounded,
                          size: 68,
                          color: (isDark ? Colors.white : AppColors.primary).withAlpha(12),
                        ),
                      ),
                      // Center doc icon
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withAlpha(isDark ? 30 : 15),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primary.withAlpha(60),
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Icons.picture_as_pdf_outlined,
                            size: 26,
                            color: AppColors.cyanGlow,
                          ),
                        ),
                      ),
                      // Top pill badges: PDF & Size
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withAlpha(isDark ? 40 : 25),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: AppColors.primary.withAlpha(60),
                              width: 0.8,
                            ),
                          ),
                          child: Text(
                            'PDF',
                            style: GoogleFonts.jetBrainsMono(
                              color: isDark ? AppColors.cyanGlow : AppColors.primary,
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.surfaceContainerHigh : Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: isDark ? AppColors.whisperBorder : AppColors.lightDivider,
                              width: 0.8,
                            ),
                          ),
                          child: Text(
                            '${document.pageCount}P · ${document.fileSizeFormatted}',
                            style: GoogleFonts.jetBrainsMono(
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              fontSize: 9.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Title and Progress info
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      document.title,
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Progress Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Study Progress',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10.5,
                            color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                          ),
                        ),
                        Text(
                          '100%',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.cyanGlow,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: const LinearProgressIndicator(
                        value: 1.0,
                        minHeight: 3,
                        backgroundColor: Color(0x1F94A3B8),
                        color: AppColors.cyanGlow,
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom Action Row
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.surfaceContainerLowest
                      : AppColors.lightSurfaceVariant,
                  border: Border(
                    top: BorderSide(
                      color: isDark ? AppColors.whisperBorder : AppColors.lightDivider,
                      width: 0.8,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: onSummaryTap,
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.summarize_outlined,
                                size: 12,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Summary',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 14,
                      color: isDark ? AppColors.whisperBorder : AppColors.lightDivider,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: onChatTap,
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          alignment: Alignment.center,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.auto_awesome, size: 12, color: AppColors.cyanGlow),
                              SizedBox(width: 4),
                              Text(
                                'Ask Doc',
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.cyanGlow,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
