import 'package:flutter/material.dart';

class FadeSlideAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final Offset beginOffset;
  final Curve curve;

  const FadeSlideAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 800),
    this.delay = Duration.zero,
    this.beginOffset = const Offset(0.0, 0.05),
    this.curve = const Cubic(0.2, 0.0, 0.0, 1.0),
  });

  @override
  State<FadeSlideAnimation> createState() => _FadeSlideAnimationState();
}

class _FadeSlideAnimationState extends State<FadeSlideAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: widget.curve);

    _slideAnimation = Tween<Offset>(
      begin: widget.beginOffset,
      end: Offset.zero,
    ).animate(_fadeAnimation);

    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(position: _slideAnimation, child: widget.child),
    );
  }
}

extension StaggeredList on List<Widget> {
  List<Widget> animateStaggered({
    Duration delay = Duration.zero,
    Duration interval = const Duration(milliseconds: 80),
  }) {
    return asMap().entries.map((entry) {
      return FadeSlideAnimation(
        delay: delay + (interval * entry.key),
        child: entry.value,
      );
    }).toList();
  }
}

extension StaggeredWidget on Widget {
  Widget animateStaggered({
    int index = 0,
    Duration delay = Duration.zero,
    Duration interval = const Duration(milliseconds: 80),
  }) {
    return FadeSlideAnimation(
      delay: delay + (interval * index),
      child: this,
    );
  }
}
