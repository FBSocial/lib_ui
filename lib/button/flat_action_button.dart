import 'package:flutter/material.dart';

class FlatActionButton extends StatelessWidget {
  final Widget? child;
  final VoidCallback? onPressed;
  final EdgeInsets padding;

  const FlatActionButton({
    Key? key,
    this.child,
    this.onPressed,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: child!,
    );
  }
}

/// todo 此处应该确认是否有规范
class TitleText extends StatelessWidget {
  final String text;
  final Color color;
  final FontWeight fontWeight;
  final int fontSize;

  const TitleText(
    this.text, {
    Key? key,
    this.color = const Color(0xFF1F2125),
    this.fontWeight = FontWeight.w500,
    this.fontSize = 17,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: 17,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
