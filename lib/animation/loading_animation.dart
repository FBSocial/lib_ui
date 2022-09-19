import 'dart:math';

import 'package:flutter/material.dart';

import '../icon_font.dart';

class LoadingAnimation extends StatefulWidget {
  final double size;
  const LoadingAnimation({Key? key, this.size = 18}) : super(key: key);

  @override
  _LoadingAnimationState createState() {
    return _LoadingAnimationState();
  }
}

class _LoadingAnimationState extends State<LoadingAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300))
      ..repeat();
    _animation = Tween<double>(begin: 0, end: pi).animate(_controller);
  }

  @override
  void dispose() {
    _controller.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _animation.value,
          child: const Icon(
            IconFont.animationLoadingBlue,
          ),
        );
      },
    );
  }
}
