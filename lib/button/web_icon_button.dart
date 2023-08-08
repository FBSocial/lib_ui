import 'package:flutter/material.dart';
import 'package:just_throttle_it/just_throttle_it.dart';

class WebIconButton extends StatefulWidget {
  final IconData? icon;

  final VoidCallback? onPressed;
  final double? size;
  final Color? color;
  final Color? hoverColor;
  final Color? highlightColor;
  final Color? disableColor;
  final EdgeInsets? padding;
  final MouseCursor? mouseCursor;

  const WebIconButton(
    this.icon, {
    Key? key,
    this.onPressed,
    this.size,
    this.color,
    this.hoverColor,
    this.highlightColor,
    this.disableColor,
    this.padding,
    this.mouseCursor = SystemMouseCursors.click,
  }) : super(key: key);

  @override
  _WebIconButtonState createState() => _WebIconButtonState();
}

class _WebIconButtonState extends State<WebIconButton> {
  bool _hover = false;
  bool _highLight = false;

  //  防抖处理
  bool isOnTap = false;

  Color get color {
    if (widget.onPressed == null) {
      return widget.disableColor ?? Theme.of(context).disabledColor;
    }
    if (_highLight) {
      return widget.highlightColor ?? Theme.of(context).highlightColor;
    }
    if (_hover) return widget.hoverColor ?? Theme.of(context).hoverColor;
    return widget.color ?? Theme.of(context).iconTheme.color!;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Container(
        color: Colors.transparent,
        padding: widget.padding ?? const EdgeInsets.all(8),
        child: InkResponse(
          mouseCursor: widget.mouseCursor,
          onHover: (hover) => setState(() => _hover = hover),
          onHighlightChanged: (highLight) =>
              setState(() => _highLight = highLight),
          onTap: widget.onPressed == null
              ? null
              : () => Throttle.milliseconds(300, widget.onPressed!),
          hoverColor: Colors.transparent,
          child: Icon(
            widget.icon,
            color: color,
            size: widget.size ?? 24,
          ),
        ),
      );

  @override
  void dispose() {
    if (widget.onPressed != null) {
      Throttle.clear(widget.onPressed!);
    }
    super.dispose();
  }
}

class WebIconBgButton extends StatefulWidget {
  final IconData? icon;

  final VoidCallback? onPressed;
  final double? size;
  final Color? color;
  final Color? hoverColor;
  final Color? highlightColor;
  final double? padding;
  final String? image;
  final Color? iconColor;
  final Color? iconHoverColor;
  final Color? iconHighlightColor;
  final Widget? child;
  final List<Shadow>? shadows;
  final Function(bool)? hoverBlock;
  final Function(bool)? highlightBlock;

  const WebIconBgButton(
    this.icon, {
    Key? key,
    this.onPressed,
    this.size,
    this.color,
    this.hoverColor,
    this.highlightColor,
    this.padding,
    this.image,
    this.iconColor,
    this.iconHoverColor,
    this.iconHighlightColor,
    this.child,
    this.shadows,
    this.hoverBlock,
    this.highlightBlock,
  }) : super(key: key);

  @override
  _WebIconBgButtonState createState() => _WebIconBgButtonState();
}

class _WebIconBgButtonState extends State<WebIconBgButton> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  bool _hover = false;
  bool _highLight = false;

  @override
  Widget build(BuildContext context) {
    final color = _highLight
        ? (widget.highlightColor ?? Theme.of(context).highlightColor)
        : _hover
            ? (widget.hoverColor ?? Theme.of(context).hoverColor)
            : (widget.color ?? Colors.transparent);
    final iconColor = _highLight
        ? (widget.iconHighlightColor ?? Theme.of(context).iconTheme.color)
        : _hover
            ? (widget.iconHoverColor ?? Theme.of(context).iconTheme.color)
            : (widget.iconColor ?? Theme.of(context).iconTheme.color);
    final size = widget.size ?? 32;
    final padding = widget.padding ?? 6;
    return InkResponse(
      onHover: (hover) {
        if (mounted) {
          setState(() => _hover = hover);
        }
        widget.hoverBlock?.call(hover);
      },
      onHighlightChanged: (highLight) {
        if (mounted) {
          setState(() => _highLight = highLight);
        }
        widget.highlightBlock?.call(highLight);
      },
      hoverColor: Colors.transparent,
      onTap: widget.onPressed,
      child: Container(
        width: size,
        height: size,
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(size / 8.0),
        ),
        child: widget.child ??
            (widget.icon == null && widget.image != null
                ? Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(widget.image!),
                        fit: BoxFit.cover, //图片填充方式
                        alignment: Alignment.topCenter, //图片位置
                        repeat: ImageRepeat.repeatY, //图片平铺方式
                      ),
                    ),
                  )
                : Icon(
                    widget.icon,
                    color: iconColor,
                    size: size - padding * 2,
                    shadows: widget.shadows,
                  )),
      ),
    );
  }
}
