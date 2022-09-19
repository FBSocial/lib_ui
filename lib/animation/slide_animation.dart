import 'package:flutter/material.dart';

/// 位移动画组件
class SlideAnimation extends StatefulWidget {
  const SlideAnimation(
      {required this.child,
      required this.begin,
      required this.end,
      required this.duration,
      this.curve,
      Key? key})
      : super(key: key);

  final Widget child;
  final Offset begin;
  final Offset end;
  final Duration duration;
  final Curve? curve;

  @override
  _SlideAnimationState createState() => _SlideAnimationState();
}

class _SlideAnimationState extends State<SlideAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late CurvedAnimation _curve;
  late Animation _animation;
  Offset? _end;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _curve = CurvedAnimation(
        parent: _controller, curve: widget.curve ?? Curves.ease);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_end == null ||
        _end!.dx != widget.end.dx ||
        _end!.dy != widget.end.dy) {
      _end = widget.end;
      _animation = Tween(begin: widget.begin, end: widget.end).animate(_curve);
      _controller.reset();
      _controller.forward();
    }

    return SlideTransition(
      position: _animation as Animation<Offset>,
      child: widget.child,
    );
  }
}
