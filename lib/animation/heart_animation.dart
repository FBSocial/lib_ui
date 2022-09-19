import 'package:flutter/material.dart';

/// 心跳动画组件
class HeartAnimation extends StatefulWidget {
  const HeartAnimation({required this.child, required this.cacheKey, Key? key})
      : super(key: key);

  final Widget child;
  final int cacheKey;

  @override
  _HeartAnimationState createState() => _HeartAnimationState();
}

class _HeartAnimationState extends State<HeartAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;
  int _cacheKey = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    final curve =
        CurvedAnimation(parent: _controller, curve: const OvershootCurve());
    _animation = Tween(begin: 0.2, end: 1).animate(curve);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cacheKey != widget.cacheKey) {
      _cacheKey = widget.cacheKey;
      _controller.reset();
      _controller.forward();

      return AnimatedBuilder(
        builder: (c, w) {
          return Transform.scale(
            scale: _animation.value,
            child: widget.child,
          );
        },
        animation: _controller,
      );
    } else {
      return widget.child;
    }
  }
}

class OvershootCurve extends Curve {
  const OvershootCurve([this.period = 3]);

  final double period;

  @override
  double transform(double t) {
    assert(t >= 0.0 && t <= 1.0);
    t -= 1.0;
    return t * t * ((period + 1) * t + period) + 1.0;
  }

  @override
  String toString() {
    return '$period';
  }
}
