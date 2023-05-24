import 'package:flutter/material.dart';

/// 缩放动画组件
class ScaleAnimation extends StatefulWidget {
  const ScaleAnimation(
      {required this.child,
      required this.begin,
      required this.end,
      required this.duration,
      this.curve,
      Key? key})
      : super(key: key);

  final Widget child;
  final double begin;
  final double end;
  final Duration duration;
  final Curve? curve;

  @override
  _ScaleAnimationState createState() => _ScaleAnimationState();
}

class _ScaleAnimationState extends State<ScaleAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late CurvedAnimation _curve;
  late Animation _animation;
  double? _end;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _curve = CurvedAnimation(
        parent: _controller, curve: widget.curve ?? Curves.ease);
    _controller.addStatusListener(_aniStatusChanged);
  }

  void _aniStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_aniStatusChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_end != widget.end) {
      _end = widget.end;
      _animation = Tween(begin: widget.begin, end: widget.end).animate(_curve);
      _controller.reset();
      _controller.forward();
    }

    return ScaleTransition(
      scale: _animation as Animation<double>,
      child: widget.child,
    );
  }
}
