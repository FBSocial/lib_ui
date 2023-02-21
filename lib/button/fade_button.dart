import 'package:flutter/material.dart';

import 'base_button.dart';

class FadeButton extends BaseButton {
  final EdgeInsets padding;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final BoxDecoration? decoration;
  final Alignment alignment;

  const FadeButton({
    Widget? child,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    this.padding = EdgeInsets.zero,
    this.height,
    this.backgroundColor,
    this.decoration,
    this.alignment = Alignment.center,
    this.width,
    Duration throttleDuration = const Duration(milliseconds: 300),
    Key? key,
  }) : super(
          child: child,
          onTap: onTap,
          onLongPress: onLongPress,
          throttleDuration: throttleDuration,
          key: key,
        );

  @override
  _FadeButtonState createState() => _FadeButtonState();
}

class _FadeButtonState extends BaseButtonState<FadeButton> {
  double _opacity = 1;

  @override
  Widget build(BuildContext context) {
    final Widget child = AnimatedOpacity(
      opacity: _opacity,
      duration: _opacity == 1 ? kThemeAnimationDuration : Duration.zero,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: widget.onTap != null ? onTap : null,
        onLongPress: widget.onLongPress != null ? onLongPress : null,
        onTapDown: (_) {
          setState(() {
            _opacity = 0.3;
          });
        },
        onTapUp: (_) => _onTapUp(),
        onTapCancel: _onTapUp,
        child: Container(
          width: widget.width,
          height: widget.height,
          padding: widget.padding,
          alignment: widget.alignment,
          child: widget.child,
        ),
      ),
    );

    return Container(
      color: widget.backgroundColor,
      decoration: widget.decoration,
      child: child,
    );
  }

  void _onTapUp() {
    setState(() {
      _opacity = 1;
    });
  }
}
