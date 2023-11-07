import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lib_utils/universal_platform.dart';

/// 点击状态栏回到顶部，需要此行为的页面请使用 [PrimaryController]
/// 如遇到特殊情况，例如一个页面内有多个需要此行为的列表时才使用此类，但是我们也应该避免出现这种情况
class ClickStatusBarToReachTop extends StatelessWidget {
  final Widget? child;
  final ScrollController? controller;

  final VoidCallback? topAction;

  const ClickStatusBarToReachTop({
    this.child,
    this.controller,
    this.topAction,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (UniversalPlatform.isIOS || UniversalPlatform.isMacOS) {
      return Stack(
        children: [
          child!,
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              controller!.animateTo(
                0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.linear,
              );
              if (topAction != null) {
                topAction!();
              }
            },
            child: SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).viewPadding.top,
            ),
          )
        ],
      );
    } else {
      return child!;
    }
  }
}
