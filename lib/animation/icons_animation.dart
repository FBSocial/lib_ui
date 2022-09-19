import 'package:flutter/material.dart';

class IconsAnimation extends StatefulWidget {
  final List<IconData>? icons;
  final Duration? duration;
  final double size;
  final Color? color;

  const IconsAnimation(
      {Key? key,
      this.icons,
      this.duration,
      this.size = 18,
      this.color = Colors.white})
      : super(key: key);

  @override
  _IconsAnimationState createState() {
    return _IconsAnimationState();
  }
}

class _IconsAnimationState extends State<IconsAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
    _animation =
        IntTween(begin: 0, end: widget.icons!.length - 1).animate(_controller);
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
        final icon = widget.icons![_animation.value];
        return Icon(
          icon,
          color: widget.color,
          size: widget.size,
        );
      },
    );
  }
}
