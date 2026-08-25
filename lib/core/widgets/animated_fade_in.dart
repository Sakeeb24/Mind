import 'package:flutter/material.dart';

/// Simple fade-in + slide-up animation for child widgets.
/// Taste Skill: Purposeful motion, not decorative.
class AnimatedFadeIn extends StatefulWidget {
  const AnimatedFadeIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 300),
    this.slideOffset = const Offset(0, 0.15),
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final Offset slideOffset;

  @override
  State<AnimatedFadeIn> createState() => _AnimatedFadeInState();
}

class _AnimatedFadeInState extends State<AnimatedFadeIn>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _offset = Tween<Offset>(
      begin: widget.slideOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _offset,
        child: widget.child,
      ),
    );
  }
}
