import 'package:flutter/material.dart';
import 'package:lib_theme/const.dart';
import 'package:lib_theme/default_theme.dart';

enum LoadingStyle {
  normal,
  style1,
}

class PrimaryButtonStyle {
  final Color? background;
  final Color? text;

  const PrimaryButtonStyle({this.background, this.text});
}

class PrimaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool enabled;
  final String label;
  final TextStyle textStyle;
  final double? borderRadius;
  final bool loading;
  final EdgeInsets? padding;

  final double? width;
  final double? height;

  final PrimaryButtonStyle? disabledStyle;

  final double loadingSize;
  final LoadingStyle loadingStyle;

  const PrimaryButton(
      {required this.onPressed,
      required this.label,
      this.enabled = true,
      this.textStyle = const TextStyle(fontSize: 17, height: 1.25),
      this.borderRadius,
      this.width,
      this.height,
      this.disabledStyle,
      this.loading = false,
      this.loadingSize = 10,
      this.loadingStyle = LoadingStyle.normal,
      this.padding,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget loadingIndicator = DefaultTheme.defaultLoadingIndicator(
        color: Colors.white, size: loadingSize);
    Widget text = Text(
      label,
      style: textStyle.copyWith(
        color: enabled ? Colors.white : (disabledStyle?.text ?? Colors.white),
      ),
    );

    Widget content;
    if (loadingStyle == LoadingStyle.style1) {
      content = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (loading) ...[
            loadingIndicator,
            sizeWidth5,
          ],
          text,
        ],
      );
    } else {
      content = loading ? loadingIndicator : text;
    }

    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
          onPressed: enabled ? onPressed : null,
          style: TextButton.styleFrom(
            padding: padding,
            shape: RoundedRectangleBorder(
                borderRadius: borderRadius == null
                    ? BorderRadius.zero
                    : BorderRadius.circular(borderRadius!)),
            backgroundColor: enabled
                ? theme.primaryColor
                : (disabledStyle?.background ??
                    theme.primaryColor.withOpacity(0.4)),
          ),
          child: content),
    );
  }
}
