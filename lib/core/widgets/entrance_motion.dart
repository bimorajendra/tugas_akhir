import 'package:flutter/material.dart';

/// A short, one-shot entrance used to give dashboard sections a clear rhythm.
/// It respects the platform's reduced-motion setting.
class EntranceMotion extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;

  const EntranceMotion({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 460),
  });

  @override
  State<EntranceMotion> createState() => _EntranceMotionState();
}

class _EntranceMotionState extends State<EntranceMotion>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _position;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.delay + widget.duration,
    );
    final totalMs = (widget.delay + widget.duration).inMilliseconds;
    final startFraction = totalMs == 0
        ? 0.0
        : widget.delay.inMilliseconds / totalMs;
    final curved = CurvedAnimation(
      parent: _controller,
      curve: Interval(startFraction, 1, curve: Curves.easeOutCubic),
    );
    _opacity = curved;
    _position = Tween<Offset>(
      begin: const Offset(0, 0.055),
      end: Offset.zero,
    ).animate(curved);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (MediaQuery.of(context).disableAnimations) {
      _controller.value = 1;
      return;
    }
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant EntranceMotion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.delay + widget.duration;
    } else if (oldWidget.delay != widget.delay) {
      _controller.duration = widget.delay + widget.duration;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).disableAnimations) return widget.child;
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(position: _position, child: widget.child),
    );
  }
}
