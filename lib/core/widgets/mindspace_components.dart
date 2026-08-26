import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mindspace/config/theme.dart';

/// Reusable Glassmorphic Panel adhering to Stitch Visual Guidelines
class MindSpaceGlassPanel extends StatelessWidget {
  const MindSpaceGlassPanel({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = 16,
    this.borderColor,
    this.backgroundColor,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? borderColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ??
            (isDark ? AppColors.darkSurface : AppColors.lightSurface),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: borderColor ??
              (isDark ? AppColors.whisperBorder : AppColors.lightDivider),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 50 : 10),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Reusable Stitch Interactive Citation Pill (`[P. 4, §3.2]`)
class MindSpaceCitationPill extends StatelessWidget {
  const MindSpaceCitationPill({
    super.key,
    required this.citation,
    this.onTap,
    this.isHighlighted = false,
  });

  final String citation;
  final VoidCallback? onTap;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: isHighlighted
                ? AppColors.primary.withAlpha(isDark ? 60 : 30)
                : (isDark ? const Color(0x1F38BDF8) : const Color(0x1538BDF8)),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isHighlighted
                  ? AppColors.primary
                  : (isDark ? AppColors.cyanGlow.withAlpha(90) : AppColors.primary.withAlpha(70)),
              width: 0.8,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.bookmark_outline_rounded,
                size: 11,
                color: isHighlighted ? AppColors.primaryLight : AppColors.cyanGlow,
              ),
              const SizedBox(width: 4),
              Text(
                citation,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isHighlighted
                      ? AppColors.primaryLight
                      : (isDark ? AppColors.cyanGlow : AppColors.primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Reusable Stitch AI Insight Block
class MindSpaceAiInsight extends StatelessWidget {
  const MindSpaceAiInsight({
    super.key,
    required this.text,
    this.title = 'AI Insight',
    this.onTap,
  });

  final String text;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceVariant : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? AppColors.cyanGlow.withAlpha(50) : AppColors.success.withAlpha(60),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_awesome,
                size: 13,
                color: isDark ? AppColors.cyanGlow : AppColors.success,
              ),
              const SizedBox(width: 5),
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.cyanGlow : AppColors.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            text,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              height: 1.4,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Reusable Stitch AI Explain Pill Button
class MindSpaceAiExplainButton extends StatelessWidget {
  const MindSpaceAiExplainButton({
    super.key,
    required this.onTap,
    this.isProcessing = false,
  });

  final VoidCallback? onTap;
  final bool isProcessing;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isProcessing ? null : onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.cyanGlow.withAlpha(25),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.cyanGlow.withAlpha(100),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isProcessing)
                const SizedBox(
                  width: 10,
                  height: 10,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    color: AppColors.cyanGlow,
                  ),
                )
              else
                const Icon(Icons.auto_awesome, size: 12, color: AppColors.cyanGlow),
              const SizedBox(width: 4),
              Text(
                isProcessing ? 'Thinking...' : 'AI Explain',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.cyanGlow,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Reusable Stitch Study Metric Tile for Dashboard
class MindSpaceStudyMetric extends StatelessWidget {
  const MindSpaceStudyMetric({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.accentColor = AppColors.primary,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.navySlate : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.whisperBorder : AppColors.lightDivider,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: accentColor.withAlpha(isDark ? 35 : 18),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: accentColor),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextTertiary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
