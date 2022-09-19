import 'package:flutter/material.dart';

/// 自定义页面切换动画 - 渐变切换
class CustomPageRouteBuilder extends PageRouteBuilder {
  // 跳转的页面
//  final Widget widget;

  CustomPageRouteBuilder(RoutePageBuilder pageBuilder)
      : super(
            opaque: false,
            transitionDuration: const Duration(milliseconds: 300),
            pageBuilder: pageBuilder,
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: Tween<double>(begin: 0, end: 1).animate(
                  CurvedAnimation(
                      parent: animation, curve: Curves.fastOutSlowIn),
                ),
                child: child,
              );
            });
}
