import 'package:flutter/material.dart';

/// 自定义页面切换效果
class CustomRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  CustomRoute(this.page, {RouteSettings? settings})
      : super(
          settings: settings,
          // 设置过度时间
          transitionDuration: const Duration(seconds: 1),
          // 构造器
          pageBuilder: (
            // 上下文和动画
            context,
            animation,
            secondaryAnimation,
          ) {
            return page;
          },
          transitionsBuilder: (
            context,
            animation,
            secondaryAnimation,
            child,
          ) {
            // 渐变效果
            return FadeTransition(
              // 从0开始到1
              opacity: Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
                // 传入设置的动画
                parent: animation,
                // 设置效果，快进漫出   这里有很多内置的效果
                curve: Curves.fastOutSlowIn,
              )),
              child: child,
            );

            // 缩放动画效果
            // return ScaleTransition(
            //   scale: Tween(begin: 0.0,end: 1.0).animate(CurvedAnimation(
            //     parent: animaton1,
            //     curve: Curves.fastOutSlowIn
            //   )),
            //   child: child,
            // );

            // 旋转加缩放动画效果
            // return RotationTransition(
            //   turns: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            //     parent: animaton1,
            //     curve: Curves.fastOutSlowIn,
            //   )),
            //   child: ScaleTransition(
            //     scale: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            //         parent: animaton1, curve: Curves.fastOutSlowIn)),
            //     child: child,
            //   ),
            // );

            // 左右滑动动画效果
            // return SlideTransition(
            //   position: Tween<Offset>(
            //           // 设置滑动的 X , Y 轴
            //           begin: Offset(-1.0, 0.0),
            //           end: Offset(0.0, 0.0))
            //       .animate(CurvedAnimation(
            //           parent: animaton1, curve: Curves.fastOutSlowIn)),
            //   child: child,
            // );
          },
        );
}
