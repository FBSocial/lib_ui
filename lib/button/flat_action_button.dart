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
