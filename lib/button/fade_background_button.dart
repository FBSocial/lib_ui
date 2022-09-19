import 'package:flutter/material.dart';

import 'base_button.dart';

class FadeBackgroundButton extends BaseButton {
  final VoidCallback? onLongPress;
  final EdgeInsets? padding;
  final double? width;
  final double? height;
  final double borderRadius;
  final List<BoxShadow>? boxShadow;
  final Color? backgroundColor;
  final Color? tapDownBackgroundColor;
  final Alignment? alignment;

  const FadeBackgroundButton({
    Widget? child,
    VoidCallback? onTap,
    this.onLongPress,
    this.padding = EdgeInsets.zero,
    this.width,
    this.height,
    this.borderRadius = 0,
    this.boxShadow,
    this.backgroundColor,
    this.alignment = Alignment.center,
    required this.tapDownBackgroundColor,
    Duration throttleDuration = const Duration(milliseconds: 300),
    Key? key,
  }) : super(
          child: child,
          onTap: onTap,
          throttleDuration: throttleDuration,
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
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        onLongPress: widget.onLongPress,
        onSecondaryTapUp: (_) => widget.onLongPress!(),
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
