import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

/// 页面路由切换Router，传入新页面的实例，其子类可扩展页面切换动画
abstract class CustomPageAnimRouter<T> extends PageRouteBuilder<T> {
  final Widget page;

  CustomPageAnimRouter(this.page, {RouteSettings? settings})
      : super(pageBuilder: (context, anim, _) => page, settings: settings);
}

class FadePageRouter extends CustomPageAnimRouter {
  FadePageRouter(Widget page) : super(page);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // implement buildTransitions
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}

class FadeThroughPageRouter<T> extends CustomPageAnimRouter<T> {
  FadeThroughPageRouter(Widget page, {RouteSettings? settings})
      : super(page, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeThroughTransition(
      animation: animation,
      secondaryAnimation: secondaryAnimation,
      child: child,
    );
  }
}

// 无转场动画路由
class NoAnimaPageRouter extends CustomPageAnimRouter {
  NoAnimaPageRouter(Widget page) : super(page);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}
