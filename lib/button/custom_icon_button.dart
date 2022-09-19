import 'package:flutter/material.dart';

class CustomIconButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final double size;
  final IconData iconData;
  final EdgeInsets padding;
  final Color? iconColor;
  final Widget? leading;

  const CustomIconButton(
      {required this.iconData,
      required this.onPressed,
      this.iconColor,
      this.size = 24,
      this.padding = const EdgeInsets.all(0),
      this.leading,
      Key? key})
      : super(key: key);

  @override
  _CustomIconButtonState createState() => _CustomIconButtonState();
}

class _CustomIconButtonState extends State<CustomIconButton> {
  bool _hover = false;

  Widget _wrapper({Widget? child}) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _hover = true);
      },
      onExit: (_) {
        setState(() => _hover = false);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
              (widget.size + widget.padding.top + widget.padding.bottom) / 2),
          color: _hover ? Colors.black.withOpacity(0.45) : Colors.transparent,
        ),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget child = SizedBox(
      height: widget.size + widget.padding.top + widget.padding.bottom,
      width: widget.size + widget.padding.left + widget.padding.right,
      child: IconButton(
        padding: const EdgeInsets.all(0),
        onPressed: widget.onPressed,
        icon: Icon(
          widget.iconData,
          size: widget.size,
          color: widget.iconColor ?? Theme.of(context).iconTheme.color,
        ),
      ),
    );
    if (widget.leading != null) {
      child = Row(
        children: [
          if (_hover) widget.leading!,
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: child,
          ),
        ],
      );
    }
    return _wrapper(
      child: child,
    );
  }
}
