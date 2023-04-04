import 'package:flutter/material.dart';

/// 去掉安卓listView的滑动水波纹
class NoRippleOverScroll extends StatefulWidget {
  final Widget child;

  const NoRippleOverScroll({required this.child, Key? key}) : super(key: key);

  @override
  NoRippleOverScrollState createState() => NoRippleOverScrollState();
}

class NoRippleOverScrollState extends State<NoRippleOverScroll> {
  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: _OverScrollBehavior(),
      child: widget.child,
    );
  }
}

class _OverScrollBehavior extends ScrollBehavior {
  //TODO 程果需要检查此处是否可以删掉,flutter3.7.8中已无此方法
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    if (getPlatform(context) == TargetPlatform.android) {
      return GlowingOverscrollIndicator(
        showLeading: false,
        showTrailing: false,
        axisDirection: axisDirection,
        color: Theme.of(context).colorScheme.secondary,
        child: child,
      );
    } else {
      return child;
    }
  }
}
