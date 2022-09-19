import 'package:flutter/material.dart';
import 'package:lib_theme/default_theme.dart';

class LoadingAction extends StatelessWidget {
  final bool loading;
  final Widget child;
  final Color? color;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final GestureTapCallback? onTap;
  final Color? loadingColor;

  const LoadingAction({
    required this.loading,
    required this.child,
    this.onTap,
    this.color,
    this.height,
    this.padding,
    this.borderRadius,
    this.loadingColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!loading && onTap != null) {
          onTap!();
        }
      },
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? 0),
          color: color,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Opacity(
              opacity: loading ? 0 : 1,
              child: Padding(
                padding: padding ?? const EdgeInsets.symmetric(horizontal: 12),
                child: child,
              ),
            ),
            Visibility(
              visible: loading,
              child: Center(
                child: DefaultTheme.defaultLoadingIndicator(
                    size: 8, color: loadingColor),
              ),
            )
          ],
        ),
      ),
    );
  }
}
