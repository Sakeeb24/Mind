import 'package:flutter/material.dart';

/// Quick pulse animation when a highlight is applied.
/// Subtle color flash that draws attention without being distracting.
class AnimatedHighlightPulse extends StatefulWidget {
  const AnimatedHighlightPulse({
    super.key,
    required this.child,
    this.color = const Color(0xFFFFEB3B),
    this.duration = const Duration(milliseconds: 400),
  });

  final Widget child;
  final Color color;
  final Duration duration;

  @override
  State<AnimatedHighlightPulse> createState() => _AnimatedHighlightPulseState();
}

class _AnimatedHighlightPulseState extends State<AnimatedHighlightPulse>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _glow = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward().then((_) {
      _controller.reverse();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glow,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: _glow.value * 0.4),
                blurRadius: _glow.value * 12,
                spreadRadius: _glow.value * 2,
              ),
            ],
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
