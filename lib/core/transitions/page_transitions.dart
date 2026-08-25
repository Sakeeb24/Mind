import 'package:flutter/material.dart';

/// Custom page transitions following Taste Skill principles:
/// - Only animate transform and opacity (compositor-friendly)
/// - Under 300ms duration
/// - Purposeful, not decorative

/// Fade + slide up — for main screen entries (login, dashboard)
Widget fadeSlideUpTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  final curved = CurvedAnimation(parent: animation, curve: Curves.easeOut);
  return FadeTransition(
    opacity: curved,
    child: SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.05),
        end: Offset.zero,
      ).animate(curved),
      child: child,
    ),
  );
}

/// Fade + slide from right — for forward navigation (login → signup)
Widget fadeSlideRightTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  final curved = CurvedAnimation(parent: animation, curve: Curves.easeOut);
  return FadeTransition(
    opacity: curved,
    child: SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.15, 0),
        end: Offset.zero,
      ).animate(curved),
      child: child,
    ),
  );
}

/// Simple fade — for modal overlays and dialogs
Widget fadeOnlyTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return FadeTransition(
    opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
    child: child,
  );
}
