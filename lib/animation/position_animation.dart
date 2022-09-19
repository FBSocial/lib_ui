import 'package:flutter/material.dart';

/// 位移动画组件
class PositionAnimation extends StatefulWidget {
  const PositionAnimation(
      {required this.child,
      required this.begin,
      required this.end,
      required this.duration,
      this.curve,
      Key? key})
      : super(key: key);

  final Widget child;
  final RelativeRect begin;
  final RelativeRect end;
  final Duration duration;
  final Curve? curve;

  @override
  _PositionAnimationState createState() => _PositionAnimationState();
}

class _PositionAnimationState extends State<PositionAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late CurvedAnimation _curve;
  late Animation _animation;
  RelativeRect? _end;

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
    final end = widget.end;
    if (_end == null ||
        _end!.left != end.left ||
        _end!.right != end.right ||
        _end!.top != end.top ||
        _end!.bottom != end.bottom) {
      _end = widget.end;
      _animation = Tween(begin: widget.begin, end: widget.end).animate(_curve);
      _controller.reset();
      _controller.forward();
    }

    return PositionedTransition(
      rect: _animation as Animation<RelativeRect>,
      child: widget.child,
    );
  }
}
