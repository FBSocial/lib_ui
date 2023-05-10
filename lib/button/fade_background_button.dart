import 'package:flutter/material.dart';

import 'base_button.dart';

class FadeBackgroundButton extends BaseButton {
  final EdgeInsets? padding;
  final double? width;
  final double? height;
  final double borderRadius;
  final List<BoxShadow>? boxShadow;
  final Color? backgroundColor;
  final Color? tapDownBackgroundColor;
  final Alignment? alignment;
  final HitTestBehavior? behavior;
  final GestureTapUpCallback? onSecondaryTapUp; //鼠标右击回调

  const FadeBackgroundButton({
    Widget? child,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    this.padding = EdgeInsets.zero,
    this.width,
    this.height,
    this.borderRadius = 0,
    this.boxShadow,
    this.backgroundColor,
    this.alignment = Alignment.center,
    this.behavior,
    required this.tapDownBackgroundColor,
    Duration throttleDuration = const Duration(milliseconds: 300),
    Key? key,
    this.onSecondaryTapUp,
  }) : super(
          child: child,
          onTap: onTap,
          throttleDuration: throttleDuration,
          onLongPress: onLongPress,
          key: key,
        );

  @override
  _FadeBackgroundButtonState createState() => _FadeBackgroundButtonState();
}

class _FadeBackgroundButtonState extends BaseButtonState<FadeBackgroundButton> {
  Color? _color;

  @override
  void initState() {
    _color = widget.backgroundColor;
    super.initState();
  }

  @override
  void didUpdateWidget(FadeBackgroundButton oldWidget) {
    if (oldWidget.backgroundColor != widget.backgroundColor) {
      _color = widget.backgroundColor;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      decoration: BoxDecoration(
          boxShadow: widget.boxShadow ?? [],
          color: _color,
          borderRadius: BorderRadius.circular(widget.borderRadius)),
      duration: _color == widget.backgroundColor
          ? kThemeAnimationDuration
          : Duration.zero,
      child: GestureDetector(
        behavior: widget.behavior ?? HitTestBehavior.opaque,
        onTap: onTap,
        onLongPress: widget.onLongPress,
        onSecondaryTapUp: (details) {
          if (widget.onSecondaryTapUp != null) {
            widget.onSecondaryTapUp?.call(details);
          } else if (widget.onLongPress != null) {
            return widget.onLongPress!();
          }
        },
        onTapDown: (_) {
          setState(() {
            _color = widget.tapDownBackgroundColor;
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
  }

  void _onTapUp() {
    setState(() {
      _color = widget.backgroundColor;
    });
  }
}
